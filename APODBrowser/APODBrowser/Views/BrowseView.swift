//
//  BrowseView.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import SwiftUI

@MainActor
struct BrowseView: View {
    @Bindable var vm: APODViewModel
    @State private var selectedDate = Date()
    @State private var path: [Route] = []
    
    enum Route: Hashable { case detail }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                DatePicker(
                    "Pick a date",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .disabled(vm.isLoading)
                
                
                Button(vm.isLoading ? "Loading..." : "Load APOD") {
                    Task {
                        await vm.load(date: selectedDate)
                        if vm.apod != nil { path.append(.detail) }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isLoading)
                .padding(.bottom)
                .accessibilityHint("Loads the Astronomy Picture of the Day for the selected date")
                
                Divider()
            }
            .navigationTitle("Browse")
            .toolbar { if vm.isLoading { ProgressView() } }
            .navigationDestination(for: Route.self) { _ in
                APODDetailView(vm: vm)
            }
        }
    }
}
