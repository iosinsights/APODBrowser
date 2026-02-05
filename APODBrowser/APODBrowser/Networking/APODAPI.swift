//
//  APODAPI.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

struct APODAPI {
    let apiKey: String
    let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
    
    func request(for date: Date?, dateFormatter: APODDateFormatting) -> URLRequest {
        var comps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        var query: [URLQueryItem] = [
            .init(name: "api_key", value: apiKey),
            .init(name: "thumbs", value: "true")
        ]
        
        if let date {
            query.append(.init(name: "date", value: dateFormatter.string(from: date)))
        }
        
        comps.queryItems = query
        return URLRequest(url: comps.url!)
    }
}
