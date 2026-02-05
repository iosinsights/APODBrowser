//
//  APODRepository.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

final class APODRepository: APODRepositoryProtocol {
    private let client: APODFetching
    private let cache: APODCaching
    
    init(client: APODFetching, cache: APODCaching) {
        self.client = client
        self.cache = cache
    }
    
    func loadCached() -> Result<APODResult, APODError> {
        do {
            guard let apod = try cache.loadAPOD() else { return .failure(.noCachedResult) }
            let media = try cache.loadImageData(for: apod.date)
            return .success(.init(apod: apod, imageData: media))
        } catch {
            return .failure(.cacheRead)
        }
    }
    
    func load(date: Date? = nil) async -> Result<APODResult, APODError> {
        do {
            
            let apod = try await client.fetchAPOD(date: date)
            
            guard let media = try await fetchDisplayMedia(for: apod) else {
                return loadCached().mapError { _ in .transport }
            }
            
            do {
                try cache.save(apod: apod)
                try cache.saveImageData(media, for: apod.date)
            } catch {
                
            }
            
            return .success(.init(apod: apod, imageData: media))
            
        } catch let e as APODError {
            return loadCached().mapError { _ in e }
        } catch {
            return loadCached().mapError { _ in .transport }
        }
    }
    
    private func fetchDisplayMedia(for apod: APOD) async throws -> Data? {
        if apod.isVideo {
            guard let thumb = apod.thumbnailUrl else { return nil }
            return try await client.fetchData(from: thumb)
        } else {
            return try await client.fetchData(from: apod.url)
        }
    }
}
