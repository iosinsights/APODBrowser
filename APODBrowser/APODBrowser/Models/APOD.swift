//
//  APOD.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import SwiftUI
import Foundation

struct APOD: Codable, Identifiable, Equatable {
    var id: String { date }
    
    let date: String
    let title: String
    let explanation: String
    let mediaType: String
    let url: URL
    let hdurl: URL?
    let thumbnailUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case date, title, explanation, url, hdurl
        case mediaType = "media_type"
        case thumbnailUrl = "thumbnail_url"
    }
    
    var isVideo: Bool { mediaType.lowercased() == "video" }
}

enum APODError: Error, Equatable {
    case transport
    case badResponse(Int)
    case decoding
    case cacheRead
    case cacheWrite
    case noCachedResult
}
