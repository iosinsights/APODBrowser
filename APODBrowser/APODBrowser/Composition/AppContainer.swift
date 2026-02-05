//
//  AppContainer.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import SwiftUI
import Foundation

struct AppContainer {
    let repository: APODRepositoryProtocol
    
    static func live() -> AppContainer {
        let http = URLSessionHTTPClient(session: .shared)
        let client = NASAClient(
            http: http,
            apiKeyProvider: BundleAPIKeyProvider()
        )
        
        let fs = DefaultFileSystem()
        let cache = APODCache(fileSystem: fs)
        
        let repo = APODRepository(client: client, cache: cache)
        return .init(repository: repo)
    }
}
