//
//  ViewModel.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class APODViewModel: APODViewModeling {
    var apod: APOD?
    var imageData: Data?
    var isLoading = false
    var errorMessage: String?
    
    private let repo: APODRepositoryProtocol
    private let clock: Clocking
    
    init(repo: APODRepositoryProtocol, clock: Clocking = SystemClock()) {
        self.repo = repo
        self.clock = clock
    }
    
    func onAppear() async {
        loadCachedOnLaunch()
        if apod == nil {
            await load(date: Date())
        }
    }
    
    func loadCachedOnLaunch() {
        switch repo.loadCached() {
        case .success(let cached):
            apod = cached.apod
            imageData = cached.imageData
            errorMessage = nil
        case .failure:
            apod = nil
            imageData = nil
        }
    }
    
    func load(date: Date? = nil) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        _ = clock
        
        switch await repo.load(date: date) {
        case .success(let value):
            apod = value.apod
            imageData = value.imageData
        case .failure(let err):
            errorMessage = userMessage(for: err)
        }
    }
    
    private func userMessage(for error: APODError) -> String {
        switch error {
        case .noCachedResult: return "No cached APOD available."
        case .badResponse(let code): return "Server error (\(code))."
        case .decoding: return "Couldn’t read the response."
        case .cacheRead: return "Couldn’t read cached data."
        case .cacheWrite: return "Loaded data but couldn’t save it offline."
        case .transport: return "Network error. Please try again."
        }
    }
}
