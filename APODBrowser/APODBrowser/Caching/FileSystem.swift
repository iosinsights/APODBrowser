//
//  FileSystem.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

protocol FileSystem {
    func exists(at url: URL) -> Bool
    func read(from url: URL) throws -> Data
    func write(_ data: Data, to url: URL, options: Data.WritingOptions) throws
    func cachesDirectory() -> URL
}

struct DefaultFileSystem: FileSystem {
    func exists(at url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
    
    func read(from url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
    
    func write(_ data: Data, to url: URL, options: Data.WritingOptions) throws {
        try data.write(to: url, options: options)
    }
    
    func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
}
