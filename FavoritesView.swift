//
//  FavoritesView.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 10/30/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query var favorites: [FavoriteEvent]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationView {
            if favorites.isEmpty {
                VStack() {
                    Image(systemName: "star")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No favorites yet!")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Add your favorite event.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
            } else {
                List {
                    ForEach(favorites) { fav in
                        VStack() {
                            Text(fav.title)
                                .font(.headline)
                            Text("\(fav.teamA) vs \(fav.teamB)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Date: \(fav.date)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("Venue: \(fav.venue)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    .onDelete(perform: deleteFavorite)
                }
                .navigationTitle("Favorites")
            }
        }
    }
    
    func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            context.delete(favorites[index])
        }
    }
}

#Preview {
    FavoritesView()
}
