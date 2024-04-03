//
//  RunningSessionView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/29/24.
//

import SwiftUI
import MapKit

struct RunningSessionView: View {
    @State var locationManager: CLLocationManager = CLLocationManager()
    @State private var mapPostion: MapCameraPosition = .automatic
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedResult: MKMapItem?
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var route: MKRoute?
    //@State private var userLocation: MKMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 42.2785424, longitude: -85.6449113)))
    
    var body: some View {
        Map(position: $mapPostion, selection: $selectedResult){
            UserAnnotation()
            
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
                
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 7)
            }
        }
        .safeAreaInset(edge: .bottom) {
            //RunningSessionStatView()
//               VStack(spacing: 0) {
//                   Text("Distance: 5mi")
//                   Text("Time: 25:00")
//                   Text("Current Pace: 9'11'")
//                   Text("Avg Pace: 25:00")
//               }
        }
        .onMapCameraChange{ context in
            visibleRegion = context.region
        }
        .onChange(of: selectedResult) {
            getDirection()
        }
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .onAppear{
            locationManager.requestWhenInUseAuthorization()
            switch locationManager.authorizationStatus {
            case .authorizedAlways:
                print("Authorized Always")
            case .authorizedWhenInUse:
                print("Authorized When In Use")
            case .denied:
                print("")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                print("Location service is not available or disabed by the user.")
            }
            mapPostion = .region(MKCoordinateRegion.userLocationRegion)
        }
    }
    
    func getDirection() {
        route = nil
        guard let selectedResult else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .userLocation))
        request.destination = selectedResult

        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}


extension CLLocationCoordinate2D {
    static let userLocation = CLLocationCoordinate2D(latitude: 42.2785424, longitude: -85.6449113)
}

extension MKCoordinateRegion {
    static let userLocationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.2785424, longitude: -85.6449113), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
}

#Preview {
    RunningSessionView()
}

//#Preview {
//    HomeScreen(locationManager: .constant(CLLocationManager()), cityName: .constant(""), cityRegion: .constant())
//}
