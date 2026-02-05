//
//  APODBrowserTests.swift
//  APODBrowserTests
//
//  Created by Kevin Reid on 05/02/2026.
//

import XCTest

final class APODBrowserTests: XCTestCase {
    
    private func makeAPOD(date: String = "2026-02-03",mediaType: String = "image", url: String = "https://example.com/media.jpg", thumbnail: String? = nil) -> APOD {
        APOD (date: date, title: "Title",
              explanation: "Explanation",
              mediaType: mediaType,
              url: URL(string: url)!,
              hdurl: nil,
              thumbnailUrl: thumbnail.flatMap(URL.init(string:))
        )
    }
    
    func testRepository_whenFetchFails_returnsCachedAPODAndMedia() async {
        let cache = InMemoryAPODCache()
        let cached = makeAPOD(date: "2026-02-01", mediaType: "image", url: "https://example.com/cached.jpg")
        let cachedMedia = Data([0xCA, 0xFE])
        
        try? cache.save(apod: cached)
        try? cache.saveImageData(cachedMedia, for: cached.date)
        
        struct FailingClient: APODFetching {
            func fetchAPOD(date: Date?) async throws -> APOD { throw APODError.transport }
            func fetchData(from url: URL) async throws -> Data { throw APODError.transport }
        }
        
        let repo = APODRepository(client: FailingClient(), cache: cache)
        
        let result = await repo.load(date: Date())
        
        switch result {
        case .success(let value):
            XCTAssertEqual(value.apod, cached)
            XCTAssertEqual(value.imageData, cachedMedia)
        case .failure(let err):
            XCTFail("Expected cached success, got failure: \(err)")
        }
    }
    
    func testRepository_whenAPODIsVideo_fetchesThumbnailNotVideoURL() async {
        final class CapturingClient: APODFetching {
            var apodToReturn: APOD
            var requestedURLs: [URL] = []
            
            init(apod: APOD) { self.apodToReturn = apod }
            
            func fetchAPOD(date: Date?) async throws -> APOD { apodToReturn }
            
            func fetchData(from url: URL) async throws -> Data {
                requestedURLs.append(url)
                return Data([0x01, 0x02])
            }
        }
        
        let videoURL = "https://www.youtube.com/embed/abc123"
        let thumbURL = "https://example.com/thumb.jpg"
        let apod = makeAPOD(date: "2026-02-02", mediaType: "video", url: videoURL, thumbnail: thumbURL)
        
        let client = CapturingClient(apod: apod)
        let cache = InMemoryAPODCache()
        let repo = APODRepository(client: client, cache: cache)
        
        let result = await repo.load(date: Date())
        
        switch result {
        case .success(let value):
            XCTAssertEqual(value.apod, apod)
            XCTAssertEqual(client.requestedURLs, [URL(string: thumbURL)!], "Should fetch thumbnail for video APOD")
        case .failure(let err):
            XCTFail("Expected success, got failure: \(err)")
        }
    }
    
    @MainActor
    func testViewModel_whenLoadFails_doesNotClearExistingApodOrImage() async {
        
        final class FlipFlopRepo: APODRepositoryProtocol {
            var shouldFail = false
            let apod: APOD
            let media: Data
            
            init(apod: APOD, media: Data) {
                self.apod = apod
                self.media = media
            }
            
            func load(date: Date?) async -> Result<APODResult, APODError> {
                if shouldFail { return .failure(.transport) }
                return .success(APODResult(apod: apod, imageData: media))
            }
            
            func loadCached() -> Result<APODResult, APODError> {
                .failure(.noCachedResult)
            }
        }
        
        let apod = makeAPOD(date: "2026-02-03", mediaType: "image", url: "https://example.com/a.jpg")
        let media = Data([0xAA])
        
        let repo = FlipFlopRepo(apod: apod, media: media)
        let vm = APODViewModel(repo: repo)
        
        await vm.load(date: Date())
        XCTAssertEqual(vm.apod, apod)
        XCTAssertEqual(vm.imageData, media)
        XCTAssertNil(vm.errorMessage)
        
        repo.shouldFail = true
        await vm.load(date: Date())
        
        XCTAssertEqual(vm.apod, apod, "Should keep last good APOD on failure")
        XCTAssertEqual(vm.imageData, media, "Should keep last good media on failure")
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }
}
