//
//  MediaResolver.swift
//  APODBrowser
//
//  Created by Kevin Reid on 05/02/2026.
//

import SwiftUI

enum MediaPresentation: Equatable {
    case image
    case nativeVideo(URL)
    case externalVideo(URL)
    case web(URL)
}

struct MediaResolver {
    func presentation(for apod: APOD) -> MediaPresentation {
        guard apod.isVideo else { return .image }
        
        if let direct = directVideoURL(from: apod.url) {
            return .nativeVideo(direct)
        }
        
        if isYouTube(apod.url) || isVimeo(apod.url) {
            return .externalVideo(watchURL(from: apod.url))
        }
        
        return .web(apod.url)
    }
    
    private func directVideoURL(from url: URL) -> URL? {
        let ext = url.pathExtension.lowercased()
        return ["mp4", "mov", "m4v", "m3u8"].contains(ext) ? url : nil
    }
    
    private func isYouTube(_ url: URL) -> Bool {
        let host = (url.host ?? "").lowercased()
        return host.contains("youtube.com") || host.contains("youtu.be")
    }
    
    private func isVimeo(_ url: URL) -> Bool {
        let host = (url.host ?? "").lowercased()
        return host.contains("vimeo.com")
    }
    
    private func watchURL(from url: URL) -> URL {
        let s = url.absoluteString
        
        if s.contains("youtube.com/embed/") {
            let id = s.components(separatedBy: "youtube.com/embed/").last?
                .components(separatedBy: ["?", "&", "/"]).first ?? ""
            return URL(string: "https://www.youtube.com/watch?v=\(id)") ?? url
        }
        
        if s.contains("youtu.be/") {
            let id = s.components(separatedBy: "youtu.be/").last?
                .components(separatedBy: ["?", "&", "/"]).first ?? ""
            return URL(string: "https://www.youtube.com/watch?v=\(id)") ?? url
        }
        
        return url
    }
}
