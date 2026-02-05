//
//  NASAClient.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

final class NASAClient: APODFetching {
    private let http: HTTPClient
    private let apiKeyProvider: APIKeyProviding
    private let decoder: JSONDecoder
    private let dateFormatter: APODDateFormatting
    
    init(
        http: HTTPClient = URLSessionHTTPClient(session: .shared),
        apiKeyProvider: APIKeyProviding = BundleAPIKeyProvider(),
        decoder: JSONDecoder = .init(),
        dateFormatter: APODDateFormatting = APODDateFormatter()
    ) {
        self.http = http
        self.apiKeyProvider = apiKeyProvider
        self.decoder = decoder
        self.dateFormatter = dateFormatter
    }
    
    func fetchAPOD(date: Date?) async throws -> APOD {
        let key = try apiKeyProvider.nasaKey()
        let api = APODAPI(apiKey: key)
        let request = api.request(for: date, dateFormatter: dateFormatter)
        
        let (data, resp) = try await http.data(for: request)
        guard (200...299).contains(resp.statusCode) else {
            throw APODError.badResponse(resp.statusCode)
        }
        
        return try decoder.decode(APOD.self, from: data)
    }
    
    func fetchData(from url: URL) async throws -> Data {
        let (data, resp) = try await http.data(for: URLRequest(url: url))
        guard (200...299).contains(resp.statusCode) else {
            throw APODError.badResponse(resp.statusCode)
        }
        return data
    }
}
