//
//  FavouriteEvent.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 10/30/25.
//

import Foundation
import SwiftData

@Model
class FavoriteEvent {
    var title: String
    var teamA: String
    var teamB: String
    var date: String
    var venue: String
    
    init(title: String, teamA: String, teamB: String, date: String, venue: String) {
        self.title = title
        self.teamA = teamA
        self.teamB = teamB
        self.date = date
        self.venue = venue
    }
}
