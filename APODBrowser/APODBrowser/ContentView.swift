//
//  ContentView.swift
//  APODBrowser
//
//  Created by Kevin Reid on 04/02/2026.
//

import SwiftUI

@MainActor
struct ContentView: View {
    private let repo: APODRepositoryProtocol

    @State private var todayVM: APODViewModel
    @State private var browseVM: APODViewModel

    init(repo: APODRepositoryProtocol) {
        self.repo = repo
        _todayVM = State(initialValue: APODViewModel(repo: repo))
        _browseVM = State(initialValue: APODViewModel(repo: repo))
    }

    var body: some View {
        TabView {
            TodayView(vm: todayVM)
                .tabItem { Label("Today", systemImage: "sun.max") }

            BrowseView(vm: browseVM)
                .tabItem { Label("Browse", systemImage: "calendar") }
        }
        .background(Color(.systemBackground))
    }
}
