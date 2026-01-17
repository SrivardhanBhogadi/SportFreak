//
//  mapView.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 11/24/25.
//

import SwiftUI
import MapKit

struct MapAnnotation: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
}

struct mapView: View {
    
    @StateObject private var viewModel = EventViewModel()
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var radiusMiles: Double = 200
    
    let phoenixCenter = CLLocationCoordinate2D(latitude: 33.4484, longitude: -112.0740)
    
    var annotationData: [MapAnnotation] {
        viewModel.events.compactMap { event in
            if let lat = event.latitude, let lng = event.longitude {
                return MapAnnotation(
                    id: event.id,
                    title: event.title,
                    subtitle: event.venue,
                    coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)
                )
            } else {
                return nil
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Radius: \(Int(radiusMiles)) miles")
                .font(.headline)
            
            Slider(value: $radiusMiles, in: 10...500, step: 10)
                .padding(.horizontal)
            
            ZStack(alignment: .bottomTrailing) {
                
                Map(position: $cameraPosition) {
                    MapCircle(center: phoenixCenter, radius: radiusMiles * 1609)
                        .foregroundStyle(.blue.opacity(0.2))
                        .stroke(.blue.opacity(0.6), lineWidth: 2)
                    
                    ForEach(annotationData) { item in
                        Marker(item.title, coordinate: item.coordinate)
                    }
                }
                .onAppear {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: phoenixCenter,
                            span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6)
                        )
                    )
                    viewModel.fetchEvents(near: phoenixCenter)
                }
                
                VStack(spacing: 12) {
                    Button(action: zoomIn) {
                        Image(systemName: "plus.magnifyingglass")
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: zoomOut) {
                        Image(systemName: "minus.magnifyingglass")
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func zoomIn() {
        if let region = cameraPosition.region {
            let newSpan = MKCoordinateSpan(
                latitudeDelta: region.span.latitudeDelta / 1.5,
                longitudeDelta: region.span.longitudeDelta / 1.5
            )
            cameraPosition = .region(MKCoordinateRegion(center: region.center, span: newSpan))
        }
    }

    func zoomOut() {
        if let region = cameraPosition.region {
            let newSpan = MKCoordinateSpan(
                latitudeDelta: region.span.latitudeDelta * 1.5,
                longitudeDelta: region.span.longitudeDelta * 1.5
            )
            cameraPosition = .region(MKCoordinateRegion(center: region.center, span: newSpan))
        }
    }
}

#Preview {
    mapView()
}
