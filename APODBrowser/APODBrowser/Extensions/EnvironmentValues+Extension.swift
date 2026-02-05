//
//  EnvironmentValues+Extension.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var urlRouter: URLRouting {
        get { self[URLRouterKey.self] }
        set { self[URLRouterKey.self] = newValue }
    }
}

private struct URLRouterKey: EnvironmentKey {
    static let defaultValue: URLRouting = NoopURLRouter()
}

final class NoopURLRouter: URLRouting {
    func open(_ url: URL) {}
}
