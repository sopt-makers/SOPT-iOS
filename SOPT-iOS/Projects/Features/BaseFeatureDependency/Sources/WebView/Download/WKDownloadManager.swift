//
//  WKDownloadManager.swift
//  BaseFeatureDependency
//
//  Created by 장석우 on 1/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers
import WebKit

public final class WKDownloadManager {
    
    private var downloadHandlers: [UTType: WKDownloadExecutable]
    var webVC: SOPTWebViewControllable?
    
    init(
        downloadHandlers: [UTType : WKDownloadExecutable] = [:],
        webVC: SOPTWebViewControllable? = nil
    ) {
        self.downloadHandlers = downloadHandlers
        self.webVC = webVC
    }
    
    public func register<T: WKDownloadExecutable>(_ object: T) {
        self.downloadHandlers[T.key] = object
    }
    
    func download(
        _ download: WKDownload,
        decideDestinationUsing response: URLResponse,
        suggestedFilename: String
    ) async -> URL? {
        guard let mimeType = response.mimeType,
              let utType = UTType(mimeType: mimeType)
        else { return nil }
        
        guard let handler = downloadHandlers.first(where: { utType.conforms(to: $0.key) })?.value
        else { return nil }
        
        return await handler.execute(download, response, suggestedFilename, webVC)
    }
    
    public static let `default`: WKDownloadManager = {
        let manager = WKDownloadManager()
        manager.register(WKImageDownloadHandler())
        return manager
    }()
}


