//
//  Location.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 11/24/25.
//

import Foundation
import CoreLocation

class Location: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func location(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
            }
        }
    }
}

