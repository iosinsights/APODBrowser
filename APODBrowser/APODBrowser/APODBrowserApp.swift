//
//  APODBrowserApp.swift
//  APODBrowser
//
//  Created by Kevin Reid on 04/02/2026.
//


import SwiftUI
import Foundation
import AVKit
import WebKit
import SafariServices
import Observation
import UIKit

@main
struct APODBrowserApp: App {
    private let container = AppContainer.live()
    @StateObject private var safariRouter = SafariURLRouter()

    var body: some Scene {
        WindowGroup {
            ContentView(repo: container.repository)
                .environment(\.urlRouter, safariRouter)
                .sheet(item: Binding(
                    get: { safariRouter.presentedURL.map(SafariSheetItem.init(url:)) },
                    set: { _ in safariRouter.presentedURL = nil }
                )) { item in
                    SafariView(url: item.url)
                }
        }
    }
}

