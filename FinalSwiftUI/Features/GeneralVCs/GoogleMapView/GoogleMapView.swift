////
////  GoogleMapView.swift
////  FinalSwiftUI
////
////  Created by Mohab Elsayed on 19/12/2024.
////
//
//import Foundation
//import SwiftUI
//import GoogleMaps
//
//import SwiftUI
//import GoogleMaps
//
//struct GoogleMapVC: View {
//    @State private var selectedLocation: CLLocationCoordinate2D? = nil
//    
//    
//    
//    var body: some View {
//        VStack {
//            GoogleMapView(selectedLocation: $selectedLocation)
//                .edgesIgnoringSafeArea(.all)
//            
//            if let location = selectedLocation {
//                Text("Selected Location: \(location.latitude), \(location.longitude)")
//                    .padding()
//            } else {
//                Text("Tap on the map to select a location.")
//                    .padding()
//            }
//        }
//    }
//}
//
//
//struct GoogleMapView: UIViewRepresentable {
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
//        var parent: GoogleMapView
//        
//        init(_ parent: GoogleMapView) {
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
//
//
//struct GoogleMapVC2: View {
//    var body: some View {
//        GoogleMapVC()
//            .edgesIgnoringSafeArea(.all)
//    }
//    
//}
//
