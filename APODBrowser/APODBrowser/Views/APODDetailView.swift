//
//  APODDetailView.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import SwiftUI

struct APODDetailView: View {
    @Bindable var vm: APODViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    private var isAccessibilitySize: Bool {
        dynamicTypeSize.isAccessibilitySize
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: isAccessibilitySize ? 20 : 16) {
                
                if let apod = vm.apod {
                    
                    header(apod)
                    
                    APODMediaView(apod: apod, imageData: vm.imageData)
                        .frame(maxWidth: .infinity)
                        .accessibilityElement(children: .contain)
                    
                    explanationSection(apod)
                    
                } else if vm.isLoading {
                    ProgressView("Loading APOD…")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                } else {
                    ContentUnavailableView(
                        "No APOD",
                        systemImage: "sparkles",
                        description: Text("Try again.")
                    )
                }
            }
            .padding(isAccessibilitySize ? 20 : 16)
        }
        .background(Color(.systemBackground))
        .overlay(alignment: .top) {
            if let msg = vm.errorMessage {
                Text(msg)
                    .font(.footnote)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(.top, 8)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
        }
    }
    
    @ViewBuilder
    private func header(_ apod: APOD) -> some View {
        if isAccessibilitySize {
            VStack(alignment: .leading, spacing: 10) {
                Text(apod.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .textSelection(.enabled)
                    .accessibilityAddTraits(.isHeader)
                
                Text(apod.date)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Date \(apod.date)")
            }
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Text(apod.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .textSelection(.enabled)
                    .accessibilityAddTraits(.isHeader)
                
                Text(apod.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Date \(apod.date)")
            }
        }
    }
    
    @ViewBuilder
    private func explanationSection(_ apod: APOD) -> some View {
        VStack(alignment: .leading, spacing: isAccessibilitySize ? 12 : 8) {
            Text("Explanation")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            Text(apod.explanation)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)
                .accessibilityLabel(apod.explanation)
        }
        .padding(.top, isAccessibilitySize ? 8 : 4)
    }
}
