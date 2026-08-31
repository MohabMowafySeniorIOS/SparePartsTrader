//
//  GooglePlacesVC.swift
//  FinalSwiftUI
//
//  Created by Mohab Elsayed on 19/12/2024.
//

import Foundation
import SwiftUI
//import GoogleMaps

//struct GooglePlacesVC: View {
//    @State private var selectedLocation: CLLocationCoordinate2D? = nil
//    
//    
//    
//    var body: some View {
//        NavigationView {
//                   PlacesSearchView()
//                       .navigationTitle("Search Places")
//               }
////        VStack {
////            GoogleMapView(selectedLocation: $selectedLocation)
////                .edgesIgnoringSafeArea(.all)
////            
////            if let location = selectedLocation {
////                Text("Selected Location: \(location.latitude), \(location.longitude)")
////                    .padding()
////            } else {
////                Text("Tap on the map to select a location.")
////                    .padding()
////            }
////        }
//    }
//}
//
//
//struct GooglePlacesView: UIViewRepresentable {
//    @Binding var selectedLocation: CLLocationCoordinate2D?
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    func makeUIView(context: Context) -> GMSMapView {
//        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 10)
//        let mapView = GMSMapView(frame: .zero, camera: camera)
//        mapView.delegate = context.coordinator
//        return mapView
//    }
//    
//    func updateUIView(_ uiView: GMSMapView, context: Context) {
//        // Update the map view if needed
//    }
//    
//    class Coordinator: NSObject, GMSMapViewDelegate {
//        var parent: GooglePlacesView
//        
//        init(_ parent: GooglePlacesView) {
//            self.parent = parent
//        }
//        
//        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//            // Update the selected location
//            parent.selectedLocation = coordinate
//            
//            // Add a marker at the tapped location
//            mapView.clear() // Remove previous markers
//            let marker = GMSMarker(position: coordinate)
//            marker.title = "Selected Location"
//            marker.map = mapView
//        }
//    }
//}
//import SwiftUI
//import GooglePlaces
//
//struct PlacesSearchView: View {
//    @State private var query = ""
//    @State private var predictions: [GMSAutocompletePrediction] = []
//    @State private var selectedPlace: GMSPlace?
//
//    var body: some View {
//        VStack {
//            TextField("Search for places", text: $query, onEditingChanged: { _ in }, onCommit: fetchPredictions)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            List(predictions, id: \.placeID) { prediction in
//                Button(action: {
//                    fetchPlaceDetails(placeID: prediction.placeID ?? "")
//                }) {
//                    Text(prediction.attributedPrimaryText.string)
//                }
//            }
//            
//            if let place = selectedPlace {
//                VStack {
//                    Text("Selected Place:")
//                        .font(.headline)
//                    Text(place.name ?? "Unknown")
//                    Text("\(place.coordinate.latitude), \(place.coordinate.longitude)")
//                }
//                .padding()
//            }
//        }
//        .onChange(of: query) { _ in
//            fetchPredictions()
//        }
//    }
//    
//    private func fetchPredictions() {
//        guard !query.isEmpty else {
//            predictions = []
//            return
//        }
//        
//        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment
//        
//        GMSPlacesClient.shared().findAutocompletePredictions(
//            fromQuery: query,
//            filter: filter,
//            sessionToken: nil
//        ) { results, error in
//            if let error = error {
//                print("Error fetching predictions: \(error)")
//                return
//            }
//            predictions = results ?? []
//        }
//    }
//    
//    private func fetchPlaceDetails(placeID: String) {
//        GMSPlacesClient.shared().fetchPlace(
//            fromPlaceID: placeID,
//            placeFields: [.name, .coordinate],
//            sessionToken: nil
//        ) { place, error in
//            if let error = error {
//                print("Error fetching place details: \(error)")
//                return
//            }
//            selectedPlace = place
//        }
//    }
//}
//
//
//struct GooglePlacesVC2: View {
//    var body: some View {
//        GooglePlacesVC()
//            .edgesIgnoringSafeArea(.all)
//    }
//    
//}
