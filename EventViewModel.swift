//
//  EventViewModel.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 10/30/25.
//

import Foundation
import CoreLocation

class EventViewModel: ObservableObject {
    @Published var events: [SportEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = "P8yP85vpoWn0qSvJ9U5y2WVaQ1LOwrGK"
    
    func fetchEvents(near coordinate: CLLocationCoordinate2D) {
        isLoading = true
        errorMessage = nil
        
        var components = URLComponents(string: "https://app.ticketmaster.com/discovery/v2/events.json")!
        components.queryItems = [
            URLQueryItem(name: "countryCode", value: "US"),
            URLQueryItem(name: "classificationName", value: "sports"),
            URLQueryItem(name: "latlong", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "radius", value: "200"),
            URLQueryItem(name: "unit", value: "miles"),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        guard let url = components.url else {
            self.isLoading = false
            self.errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { self.isLoading = false }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { self.errorMessage = "No data received" }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(Response.self, from: data)
                let mappedEvents = decoded.toSportEvents()
                DispatchQueue.main.async { self.events = mappedEvents }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "JSON parse error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct Response: Decodable {
    let embedded: EmbeddedEvents?
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedEvents: Decodable {
    let events: [Event]
}

struct Event: Decodable {
    let name: String
    let dates: Dates
    let embedded: EmbeddedVenues?
    enum CodingKeys: String, CodingKey {
        case name, dates
        case embedded = "_embedded"
    }
}

struct Dates: Decodable {
    let start: Start
}

struct Start: Decodable {
    let localDate: String?
    let localTime: String?
}

struct EmbeddedVenues: Decodable {
    let venues: [Venue]
}

struct Venue: Decodable {
    let name: String?
    let city: City?
    let state: state?
    let location: location?
}

struct City: Decodable {
    let name: String?
}

struct state: Decodable {
    let stateCode: String?
}

struct location: Decodable {
    let latitude: String?
    let longitude: String?
}


extension Response {
    func toSportEvents() -> [SportEvent] {
        guard let events = embedded?.events else { return [] }
        
        return events.compactMap { ev in
            let venue = ev.embedded?.venues.first
            let venueName = venue?.name ?? "Unknown Venue"
            let city = venue?.city?.name ?? ""
            let stateCode = venue?.state?.stateCode ?? ""

            let fullVenue = [venueName, city, stateCode]
                .filter { !$0.isEmpty }
                .joined(separator: ", ")

            let date = ev.dates.start.localDate ?? "TBA"

            var latitude: Double? = nil
            var longitude: Double? = nil

            if let latStr = venue?.location?.latitude,
               let lngStr = venue?.location?.longitude {
                latitude = Double(latStr)
                longitude = Double(lngStr)
            }

            return SportEvent(
                title: ev.name,
                sportType: "Sports",
                teamA: "",
                teamB: "",
                date: date,
                venue: fullVenue,
                latitude: latitude,
                longitude: longitude
            )
        }
    }
}
