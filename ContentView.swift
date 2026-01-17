//
//  ContentView.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 10/30/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let event: SportEvent
    @Environment(\.modelContext) private var context
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(event.title)
                    .font(.title2)
                    .bold()
                Text("Date: \(event.date)")
                    .font(.body)
                Text("Venue: \(event.venue)")
                    .font(.body)
                
                if let lat = event.latitude, let lng = event.longitude {
                    Text("Coordinates: \(lat), \(lng)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Divider().padding(.vertical)
                
                Button(action: addToFavorites) {
                    Label("Add to Favorites", systemImage: "star.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Event Details")
    }
    
    func addToFavorites() {
        let favorite = FavoriteEvent(
            title: event.title,
            teamA: event.teamA,
            teamB: event.teamB,
            date: event.date,
            venue: event.venue
        )
        context.insert(favorite)
    }
}

#Preview {
    ContentView(
        event: SportEvent(
            title: "Example Match",
            sportType: "Football",
            teamA: "Team A",
            teamB: "Team B",
            date: "Dec 12, 2025",
            venue: "Sun Devil Stadium",
            latitude: 33.4263,
            longitude: -111.9350
        )
    )
}
