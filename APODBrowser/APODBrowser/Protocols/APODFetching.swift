//
//  APODFetching.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

protocol APODFetching {
    func fetchAPOD(date: Date?) async throws -> APOD
    func fetchData(from url: URL) async throws -> Data
}
