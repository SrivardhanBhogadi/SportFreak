//
//  SportEvent.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 10/30/25.
//

import Foundation

struct SportEvent: Identifiable {
    let id = UUID()
    var title: String
    var sportType: String
    var teamA: String
    var teamB: String
    var date: String
    var venue: String
    var latitude: Double?
    var longitude: Double?
}

