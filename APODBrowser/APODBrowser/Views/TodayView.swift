//
//  TodayView.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import SwiftUI

@MainActor
struct TodayView: View {
    @Bindable var vm: APODViewModel
    var body: some View {
        NavigationStack {
            APODDetailView(vm: vm)
                .navigationTitle("Today")
                .toolbar {
                    Button {
                        Task { await vm.load(date: Date()) }
                        
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                                .accessibilityLabel("Loading")
                        } else {
                            Text("Reload")
                        }
                    }
                    .disabled(vm.isLoading)
                    .accessibilityHint("Reloads the current day's Astronomy Picture of the Day")
                }
                .task { await vm.onAppear() }
        }
    }
}
