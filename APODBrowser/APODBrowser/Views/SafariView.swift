//
//  SafariView.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import SwiftUI
import Foundation
//import AVKit
import WebKit
import SafariServices
import UIKit

public struct SafariSheetItem: Identifiable {
    public let id = UUID()
    let url: URL
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController { SFSafariViewController(url: url) }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

final class SafariURLRouter: ObservableObject, URLRouting {
    @Published var presentedURL: URL?
    
    func open(_ url: URL) {
        presentedURL = url
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ uiView: WKWebView, context: Context) { uiView.load(URLRequest(url: url)) }
}
