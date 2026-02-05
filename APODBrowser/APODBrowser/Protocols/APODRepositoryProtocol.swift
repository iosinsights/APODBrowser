//
//  APODRepositoryProtocol.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

protocol APODRepositoryProtocol {
    func load(date: Date?) async -> Result<APODResult, APODError>
    func loadCached() -> Result<APODResult, APODError>
}
