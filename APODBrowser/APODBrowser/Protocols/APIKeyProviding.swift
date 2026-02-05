//
//  APIKeyProviding.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

protocol APIKeyProviding {
    func nasaKey() throws -> String
}

enum APIKeyError: Error, Equatable {
    case missingKey
}
