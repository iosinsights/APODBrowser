//
//  HTTPClient.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation

protocol HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
