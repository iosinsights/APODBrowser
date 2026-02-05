//
//  APODCache.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation
import SwiftUI

struct APODCache: APODCaching {
    private let apodFile = "last_apod.json"
    private let directory: URL
    private let fs: FileSystem
    
    init(fileSystem: FileSystem, directory: URL? = nil) {
        self.fs = fileSystem
        self.directory = directory ?? fileSystem.cachesDirectory()
    }
    
    private func fileURL(_ name: String) -> URL {
        directory.appendingPathComponent(name)
    }
    
    func save(apod: APOD) throws {
        let data = try JSONEncoder().encode(apod)
        try fs.write(data, to: fileURL(apodFile), options: [.atomic])
    }
    
    func loadAPOD() throws -> APOD? {
        let url = fileURL(apodFile)
        guard fs.exists(at: url) else { return nil }
        let data = try fs.read(from: url)
        return try JSONDecoder().decode(APOD.self, from: data)
    }
    
    func saveImageData(_ data: Data, for date: String) throws {
        try fs.write(data, to: fileURL(mediaFileName(for: date)), options: [.atomic])
    }
    
    func loadImageData(for date: String) throws -> Data? {
        let url = fileURL(mediaFileName(for: date))
        guard fs.exists(at: url) else { return nil }
        return try fs.read(from: url)
    }
    
    private func mediaFileName(for date: String) -> String {
        "apod_\(date).dat"
    }
}
