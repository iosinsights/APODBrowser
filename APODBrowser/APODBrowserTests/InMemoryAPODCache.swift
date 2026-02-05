//
//  InMemoryAPODCache.swift
//  APODBrowserTests
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

final class InMemoryAPODCache: APODCaching {
    private var storedApod: APOD?
    private var storedMediaByDate: [String: Data] = [:]
    
    func save(apod: APOD) throws { storedApod = apod }
    func loadAPOD() throws -> APOD? { storedApod }
    
    func saveImageData(_ data: Data, for date: String) throws { storedMediaByDate[date] = data }
    func loadImageData(for date: String) throws -> Data? { storedMediaByDate[date] }
}

final class TestURLRouter: URLRouting {
    private(set) var opened: [URL] = []
    func open(_ url: URL) { opened.append(url) }
}

final class InMemoryFileSystem: FileSystem {
    private var store: [String: Data] = [:]
    private let base: URL
    
    init(base: URL = URL(fileURLWithPath: "/tmp/inmemory-cache")) {
        self.base = base
    }
    
    func cachesDirectory() -> URL { base }
    
    func exists(at url: URL) -> Bool { store[url.path] != nil }
    
    func read(from url: URL) throws -> Data {
        guard let d = store[url.path] else { throw APODError.cacheRead }
        return d
    }
    
    func write(_ data: Data, to url: URL, options: Data.WritingOptions) throws {
        store[url.path] = data
    }
}
