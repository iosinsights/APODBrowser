//
//  Clocking.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

protocol Clocking {
    func sleep(nanoseconds: UInt64) async throws
}

struct SystemClock: Clocking {
    func sleep(nanoseconds: UInt64) async throws {
        try await Task.sleep(nanoseconds: nanoseconds)
    }
}
