//
//  APODViewModeling.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation
import SwiftUI

@MainActor
protocol APODViewModeling: AnyObject {
    var apod: APOD? { get }
    var imageData: Data? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func loadCachedOnLaunch()
    func load(date: Date?) async
    func onAppear() async
}
