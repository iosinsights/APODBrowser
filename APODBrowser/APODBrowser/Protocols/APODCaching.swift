//
//  APODCaching.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

protocol APODCaching {
    func save(apod: APOD) throws
    func loadAPOD() throws -> APOD?
    func saveImageData(_ data: Data, for date: String) throws
    func loadImageData(for date: String) throws -> Data?
}
