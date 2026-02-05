//
//  BundleAPIKeyProvider.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

struct BundleAPIKeyProvider: APIKeyProviding {
    func nasaKey() throws -> String {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "NASA_API_KEY") as? String,
            !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            throw APIKeyError.missingKey
        }
        
        return key
    }
}
