//
//  SportEvent.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 10/30/25.
//

import SwiftUI
import SwiftData

@main
struct SportFreakApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([FavoriteEvent.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                EventListView()
                    .tabItem { Label("Events", systemImage: "sportscourt") }
                
                mapView()
                    .tabItem { Label("Map", systemImage: "mappin") }
                
                FavoritesView()
                    .tabItem { Label("Favorites", systemImage: "star.fill") }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
