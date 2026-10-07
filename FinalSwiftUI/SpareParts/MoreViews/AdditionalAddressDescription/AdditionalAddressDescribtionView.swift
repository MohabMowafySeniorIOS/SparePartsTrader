//
//  AddAddressView.swift
//  SpareParts
//
//  Created by Mohab on 13/02/2026.
//

import Foundation
import SwiftUI
import GoogleMaps
import CoreLocation


// MARK: - Height Preference Key

private struct SheetHeightKey: PreferenceKey {

    static var defaultValue: CGFloat = 0

    static func reduce(
        value: inout CGFloat,
        nextValue: () -> CGFloat
    ) {
        value = max(value, nextValue())
    }
}

private struct TopBarHeightKey: PreferenceKey {

    static var defaultValue: CGFloat = 0

    static func reduce(
        value: inout CGFloat,
        nextValue: () -> CGFloat
    ) {
        value = max(value, nextValue())
    }
}


// MARK: - Google Map

struct TraderGoogleMapView: UIViewRepresentable {

    @Binding var camera: GMSCameraPosition

    /// المساحة المغطاة بالهيدر والبحث من فوق
    var topPadding: CGFloat = 0

    /// المساحة المغطاة بالشيت من تحت
    var bottomPadding: CGFloat = 0

    /// بيتنده أول ما المستخدم يبدأ يحرك الخريطة
    var onMoveStarted: (() -> Void)?

    /// بيتنده لما الخريطة تقف
    var onCameraIdle: ((GMSCameraPosition) -> Void)?


    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }


    func makeUIView(context: Context) -> GMSMapView {

        let mapView = GMSMapView(
            frame: .zero,
            camera: camera
        )

        mapView.isMyLocationEnabled = true

        // عندنا زرار GPS بتاعنا في الشيت
        mapView.settings.myLocationButton = false
        mapView.settings.compassButton = false
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false

        mapView.delegate = context.coordinator

        mapView.padding = UIEdgeInsets(
            top: topPadding,
            left: 0,
            bottom: bottomPadding,
            right: 0
        )

        context.coordinator.lastTarget = camera.target

        return mapView
    }


    func updateUIView(
        _ uiView: GMSMapView,
        context: Context
    ) {

        context.coordinator.parent = self

        /*
         الـ padding بيخلي مركز الخريطة (camera.target)
         في نص المساحة الظاهرة مش نص الشاشة،
         عشان الدبوس يطابق المكان المختار بالظبط.
         */
        let insets = UIEdgeInsets(
            top: topPadding,
            left: 0,
            bottom: bottomPadding,
            right: 0
        )

        if uiView.padding != insets {
            uiView.padding = insets
        }

        /*
         نحرك الخريطة بس لما التغيير يكون جاي من الكود
         (زي زرار الموقع الحالي أو نتيجة بحث)،
         مش وإحنا بنسحب بالإيد.
         */
        guard context.coordinator.isUserGesture == false else {
            return
        }

        if context.coordinator.isDifferent(
            from: camera.target
        ) {

            context.coordinator.lastTarget = camera.target

            uiView.animate(to: camera)
        }
    }


    // MARK: - Coordinator

    final class Coordinator: NSObject, GMSMapViewDelegate {

        var parent: TraderGoogleMapView

        var lastTarget: CLLocationCoordinate2D?

        var isUserGesture = false


        init(parent: TraderGoogleMapView) {
            self.parent = parent
        }


        func isDifferent(
            from target: CLLocationCoordinate2D
        ) -> Bool {

            guard let lastTarget else {
                return true
            }

            let latDiff = abs(
                lastTarget.latitude - target.latitude
            )

            let lngDiff = abs(
                lastTarget.longitude - target.longitude
            )

            return latDiff > 0.000001 || lngDiff > 0.000001
        }


        func mapView(
            _ mapView: GMSMapView,
            willMove gesture: Bool
        ) {

            if gesture {
                isUserGesture = true
                parent.onMoveStarted?()
            }
        }


        func mapView(
            _ mapView: GMSMapView,
            idleAt position: GMSCameraPosition
        ) {

            isUserGesture = false
            lastTarget = position.target

            parent.onCameraIdle?(position)
        }
    }
}


// MARK: - Location Manager

final class AddressLocationManager: NSObject,
                                    ObservableObject,
                                    CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var isLocating = false
    @Published var isDenied = false

    private var completion: ((CLLocationCoordinate2D) -> Void)?


    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }


    func requestLocation(
        completion: @escaping (CLLocationCoordinate2D) -> Void
    ) {

        self.completion = completion

        switch manager.authorizationStatus {

        case .notDetermined:
            isLocating = true
            manager.requestWhenInUseAuthorization()

        case .denied, .restricted:
            isDenied = true

        default:
            isLocating = true
            manager.requestLocation()
        }
    }


    func openSettings() {

        guard
            let url = URL(
                string: UIApplication.openSettingsURLString
            )
        else {
            return
        }

        UIApplication.shared.open(url)
    }


    // MARK: Delegate

    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {

        switch manager.authorizationStatus {

        case .authorizedWhenInUse, .authorizedAlways:
            isDenied = false

            if isLocating {
                manager.requestLocation()
            }

        case .denied, .restricted:
            isLocating = false
            isDenied = true

        default:
            break
        }
    }


    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        isLocating = false

        guard let location = locations.last else {
            return
        }

        completion?(location.coordinate)
        completion = nil
    }


    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {

        isLocating = false
    }
}


// MARK: - Address View

struct TraderAdditionalAddressDescribtionView: View {

    @State private var camera = GMSCameraPosition(
        latitude: 24.7136,
        longitude: 46.6753,
        zoom: 16
    )

    @State private var address = ""
    @State private var details = ""

    @State private var searchText = ""
    @State private var searchResults: [CLPlacemark] = []
    @State private var isSearching = false
    @State private var showResults = false

    @State private var isLoadingAddress = false
    @State private var isMapMoving = false

    @State private var sheetHeight: CGFloat = 0
    @State private var topBarHeight: CGFloat = 0

    @State private var didPrefill = false

    @StateObject private var locationManager = AddressLocationManager()

    @FocusState private var isSearchFocused: Bool

    @ObservedObject var viewModel: AdditionalAddressDescribtionViewModel

    private let geocoder = CLGeocoder()


    init(
        viewModel: AdditionalAddressDescribtionViewModel
    ) {
        _viewModel = ObservedObject(
            wrappedValue: viewModel
        )
    }


    private var isEditing: Bool {
        viewModel.addressModel?.id != nil
    }


    private var canSubmit: Bool {

        isLoadingAddress == false &&
        isMapMoving == false &&
        address.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty == false
    }


    // MARK: - Body

    var body: some View {

        ZStack(alignment: .top) {

            mapLayer

            centerPin

            VStack(spacing: 0) {

                topBar

                Spacer(minLength: 0)

                bottomSheet
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .background(Color(Color.backGroundColor))
        .onPreferenceChange(SheetHeightKey.self) { value in
            sheetHeight = value
        }
        .onPreferenceChange(TopBarHeightKey.self) { value in
            topBarHeight = value
        }
        .onAppear {
            prefillIfNeeded()
        }
        .alert(
            "location_permission_denied".localized,
            isPresented: $locationManager.isDenied
        ) {

            Button("cancel".localized, role: .cancel) { }

            Button("open_settings".localized) {
                locationManager.openSettings()
            }
        }
    }
}


// MARK: - Map Layer

extension TraderAdditionalAddressDescribtionView {

    private var mapLayer: some View {

        TraderGoogleMapView(
            camera: $camera,
            topPadding: topBarHeight,
            bottomPadding: sheetHeight,
            onMoveStarted: {

                if isMapMoving == false {
                    withAnimation(.easeOut(duration: 0.15)) {
                        isMapMoving = true
                    }
                }

                showResults = false
                isSearchFocused = false
            },
            onCameraIdle: { position in

                camera = position

                withAnimation(.easeOut(duration: 0.15)) {
                    isMapMoving = false
                }

                reverseGeocode(
                    latitude: position.target.latitude,
                    longitude: position.target.longitude
                )
            }
        )
        .ignoresSafeArea()
    }


    /// الدبوس في نص المساحة الظاهرة من الخريطة
    /// (بين الهيدر والشيت) عشان يطابق النقطة المختارة
    private var centerPin: some View {

        GeometryReader { geo in

            let visibleHeight = max(
                geo.size.height - topBarHeight - sheetHeight,
                0
            )

            let centerY = topBarHeight + (visibleHeight / 2)

            VStack(spacing: 0) {

                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 38))
                    .foregroundColor(Color.MainColor)
                    .background(
                        Circle()
                            .fill(Color.CWhite)
                            .frame(width: 26, height: 26)
                    )
                    .offset(y: isMapMoving ? -10 : 0)

                // ظل صغير تحت الدبوس يوضح النقطة بالظبط
                Ellipse()
                    .fill(Color.black.opacity(0.25))
                    .frame(
                        width: isMapMoving ? 14 : 10,
                        height: isMapMoving ? 5 : 4
                    )
                    .blur(radius: 1)
                    .padding(.top, 2)
            }
            // الطرف السفلي للدبوس هو النقطة المختارة
            .offset(y: -22)
            .position(
                x: geo.size.width / 2,
                y: centerY
            )
        }
        .allowsHitTesting(false)
    }
}


// MARK: - Top Bar

extension TraderAdditionalAddressDescribtionView {

    private var topBar: some View {

        VStack(spacing: 0) {

            AppHeaderView(
                Title: "select_location_on_map".localized
            ) {
                viewModel.disMiss()
            }

            searchBar
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 8)

            if showResults {
                searchResultsList
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: TopBarHeightKey.self,
                    value: geo.size.height
                )
            }
        )
    }


    private var searchBar: some View {

        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.MainColor)

            TextField(
                "Search About Address".localized,
                text: $searchText
            )
            .focused($isSearchFocused)
            .submitLabel(.search)
            .onSubmit {
                searchAddress()
            }

            if isSearching {

                ProgressView()
                    .scaleEffect(0.7)

            } else if searchText.isEmpty == false {

                Button {
                    searchText = ""
                    searchResults = []
                    showResults = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.CGray2)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.CWhite)
        )
        .shadow(
            color: .black.opacity(0.12),
            radius: 6,
            x: 0,
            y: 2
        )
    }


    private var searchResultsList: some View {

        VStack(spacing: 0) {

            if searchResults.isEmpty {

                HStack {
                    Text("no_search_results".localized)
                        .font(addFont(fontType: .Medium, size: 14))
                        .foregroundStyle(Color.CGray1)
                    Spacer()
                }
                .padding()

            } else {

                ForEach(
                    Array(searchResults.enumerated()),
                    id: \.offset
                ) { index, placemark in

                    Button {
                        select(placemark: placemark)
                    } label: {

                        HStack(spacing: 10) {

                            Image(systemName: "mappin.circle")
                                .foregroundColor(Color.MainColor)

                            Text(readableAddress(from: placemark))
                                .font(addFont(fontType: .Medium, size: 14))
                                .foregroundStyle(Color.CBlack)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)

                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                    }

                    if index < searchResults.count - 1 {
                        Divider()
                            .padding(.horizontal, 14)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.CWhite)
        )
        .shadow(
            color: .black.opacity(0.12),
            radius: 6,
            x: 0,
            y: 2
        )
    }
}


// MARK: - Bottom Sheet

extension TraderAdditionalAddressDescribtionView {

    private var bottomSheet: some View {

        VStack(spacing: 14) {

            // Grabber
            Capsule()
                .fill(Color.CGray2.opacity(0.5))
                .frame(width: 44, height: 5)
                .padding(.top, 8)

            selectedAddressCard

            descriptionField

            actionButtons
        }
        .padding(.horizontal)
        .padding(.bottom, 28)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(Color.backGroundColor))
                .ignoresSafeArea(edges: .bottom)
                .shadow(
                    color: .black.opacity(0.12),
                    radius: 10,
                    x: 0,
                    y: -3
                )
        )
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: SheetHeightKey.self,
                    value: geo.size.height
                )
            }
        )
    }


    private var selectedAddressCard: some View {

        HStack(alignment: .top, spacing: 10) {

            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(Color.MainColor)
                .font(.system(size: 18))

            VStack(alignment: .leading, spacing: 4) {

                Text("selected_location".localized)
                    .font(addFont(fontType: .bold, size: 13))
                    .foregroundStyle(Color.MainColor)

                Group {

                    if isMapMoving {

                        Text("move_map_to_select".localized)
                            .foregroundStyle(Color.CGray1)

                    } else if isLoadingAddress {

                        HStack(spacing: 6) {
                            ProgressView()
                                .scaleEffect(0.7)
                            Text("loading".localized)
                                .foregroundStyle(Color.CGray1)
                        }

                    } else if address.isEmpty {

                        Text("move_map_to_select".localized)
                            .foregroundStyle(Color.CGray1)

                    } else {

                        Text(address)
                            .foregroundStyle(Color.CBlack)
                    }
                }
                .font(addFont(fontType: .Medium, size: 14))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.CWhite)
        )
        .shadow(
            color: .black.opacity(0.06),
            radius: 6,
            x: 0,
            y: 2
        )
    }


    private var descriptionField: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text("Additional description of the title".localized)
                .foregroundColor(Color.MainColor)
                .font(addFont(fontType: .bold, size: 14))

            ZStack(alignment: .topLeading) {

                TextEditor(text: $details)
                    .frame(height: 80)
                    .padding(6)
                    .scrollContentBackground(.hidden)
                    .background(Color.CWhite)
                    .cornerRadius(14)

                if details.isEmpty {

                    Text("address_description_hint".localized)
                        .font(addFont(fontType: .Medium, size: 14))
                        .foregroundStyle(Color.CGray2)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .allowsHitTesting(false)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.CWhite)
            )
            .shadow(
                color: .black.opacity(0.06),
                radius: 6,
                x: 0,
                y: 2
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }


    private var actionButtons: some View {

        HStack(spacing: 12) {

            Button {
                goToCurrentLocation()
            } label: {

                HStack(spacing: 6) {

                    if locationManager.isLocating {
                        ProgressView()
                            .scaleEffect(0.7)
                    } else {
                        Image(systemName: "location.fill")
                    }

                    Text("automatic_gps".localized)
                        .font(addFont(fontType: .bold, size: 14))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(Color.MainColor)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.MainColor, lineWidth: 1)
                )
            }
            .disabled(locationManager.isLocating)

            Button {
                addAddress()
            } label: {

                Text(
                    (isEditing ? "Save" : "add").localized
                )
                .font(addFont(fontType: .bold, size: 15))
                .foregroundStyle(Color.CWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            canSubmit
                            ? Color.MainColor
                            : Color.CGray2
                        )
                )
            }
            .disabled(canSubmit == false)
        }
    }
}


// MARK: - Prefill

extension TraderAdditionalAddressDescribtionView {

    private func prefillIfNeeded() {

        guard didPrefill == false else {
            return
        }

        didPrefill = true

        if
            let model = viewModel.addressModel,
            let latitude = model.latitude,
            let longitude = model.longitude,
            latitude != 0 || longitude != 0 {

            // تعديل عنوان موجود
            camera = GMSCameraPosition(
                latitude: latitude,
                longitude: longitude,
                zoom: 16
            )

            address = model.address_text ?? model.title ?? ""
            details = model.description ?? ""

            reverseGeocodeIfNeeded(
                latitude: latitude,
                longitude: longitude
            )

        } else {

            // عنوان جديد: نبدأ من مكان المستخدم لو متاح
            reverseGeocode(
                latitude: camera.target.latitude,
                longitude: camera.target.longitude
            )

            goToCurrentLocation()
        }
    }


    private func reverseGeocodeIfNeeded(
        latitude: Double,
        longitude: Double
    ) {

        guard address.isEmpty else {
            return
        }

        reverseGeocode(
            latitude: latitude,
            longitude: longitude
        )
    }
}


// MARK: - Geocoding

extension TraderAdditionalAddressDescribtionView {

    private func reverseGeocode(
        latitude: Double,
        longitude: Double
    ) {

        isLoadingAddress = true

        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }

        let location = CLLocation(
            latitude: latitude,
            longitude: longitude
        )

        geocoder.reverseGeocodeLocation(
            location
        ) { placemarks, error in

            DispatchQueue.main.async {

                isLoadingAddress = false

                guard
                    error == nil,
                    let placemark = placemarks?.first
                else {
                    return
                }

                address = readableAddress(from: placemark)
            }
        }
    }


    private func searchAddress() {

        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard query.isEmpty == false else {
            searchResults = []
            showResults = false
            return
        }

        isSearching = true

        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }

        geocoder.geocodeAddressString(
            query
        ) { placemarks, _ in

            DispatchQueue.main.async {

                isSearching = false
                searchResults = Array(
                    (placemarks ?? []).prefix(5)
                )
                showResults = true
            }
        }
    }


    private func select(placemark: CLPlacemark) {

        guard
            let coordinate = placemark.location?.coordinate
        else {
            return
        }

        showResults = false
        isSearchFocused = false
        searchText = ""

        address = readableAddress(from: placemark)

        camera = GMSCameraPosition(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            zoom: 16
        )
    }


    private func readableAddress(
        from placemark: CLPlacemark
    ) -> String {

        var components: [String] = []

        if let name = placemark.name {
            components.append(name)
        }

        if let subLocality = placemark.subLocality {
            components.append(subLocality)
        }

        if let locality = placemark.locality {
            components.append(locality)
        }

        if let administrativeArea = placemark.administrativeArea {
            components.append(administrativeArea)
        }

        if let country = placemark.country {
            components.append(country)
        }

        // شيل التكرار مع الحفاظ على الترتيب
        var unique: [String] = []

        for item in components where unique.contains(item) == false {
            unique.append(item)
        }

        return unique.joined(separator: ", ")
    }
}


// MARK: - Current Location

extension TraderAdditionalAddressDescribtionView {

    private func goToCurrentLocation() {

        locationManager.requestLocation { coordinate in

            camera = GMSCameraPosition(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                zoom: 16
            )

            reverseGeocode(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        }
    }
}


// MARK: - Add Address

extension TraderAdditionalAddressDescribtionView {

    private func addAddress() {

        let selectedAddress = address.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let selectedDescription = details.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard selectedAddress.isEmpty == false else {
            return
        }

        viewModel.onLocationSelected?(
            selectedAddress,
            String(camera.target.latitude),
            String(camera.target.longitude)
        )
        viewModel.disMiss()
    }
}
