//
//  EventListView.swift
//  SportFreak
//
//  Created by Srivardhan Bhogadi on 10/30/25.
//

import SwiftUI
import CoreLocation

struct EventListView: View {
    @StateObject private var viewModel = EventViewModel()

    let phoenixCenter = CLLocationCoordinate2D(latitude: 33.4484, longitude: -112.0740)

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.events) { event in
                    NavigationLink(destination: ContentView(event: event)) {
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.headline)
                            Text(event.venue)
                                .font(.caption)
                            Text(event.date)
                                .font(.caption2)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchEvents(near: phoenixCenter)
                }
            }
            .navigationTitle("Sport Freak")
        }
    }
}

#Preview {
    EventListView()
}
