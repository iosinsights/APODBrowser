//
//  APODMediaView.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import SwiftUI
import Foundation
import AVKit

struct APODMediaView: View {
    let apod: APOD
    let imageData: Data?
    
    @Environment(\.urlRouter) private var urlRouter
    private let resolver = MediaResolver()
    
    @State private var player: AVPlayer?
    
    var body: some View {
        switch resolver.presentation(for: apod) {
        case .image:
            imageBody
            
        case .nativeVideo(let url):
            VStack(spacing: 12) {
                previewImage
                VideoPlayer(player: player)
                    .frame(minHeight: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onAppear { if player == nil { player = AVPlayer(url: url) } }
                    .onDisappear { player?.pause() }
            }
            
        case .externalVideo(let url):
            VStack(spacing: 12) {
                previewImage
                Button {
                    urlRouter.open(url)
                } label: {
                    Label("Play video", systemImage: "play.rectangle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            
        case .web(let url):
            VStack(spacing: 12) {
                previewImage
                WebView(url: url)
                    .frame(minHeight: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button {
                    urlRouter.open(url)
                } label: {
                    Label("Open in Safari", systemImage: "safari")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private var imageBody: some View {
        Group {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ContentUnavailableView(
                    "No image",
                    systemImage: "photo",
                    description: Text("This APOD didn’t include an image payload.")
                )
            }
        }
    }
    
    @ViewBuilder
    private var previewImage: some View {
        if let imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
