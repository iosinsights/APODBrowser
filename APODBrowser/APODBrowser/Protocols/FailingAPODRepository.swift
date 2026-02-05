//
//  FailingAPODRepository.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

struct FailingAPODRepository: APODRepositoryProtocol {
    func load(date: Date?) async -> Result<APODResult, APODError> { .failure(.transport) }
    func loadCached() -> Result<APODResult, APODError> { .failure(.noCachedResult) }
}
