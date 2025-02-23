//
//  WKDownloadExecutable.swift
//  BaseFeatureDependency
//
//  Created by 장석우 on 1/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers
import WebKit

public protocol WKDownloadExecutable {
    
    static var key: UTType { get }
    
    func execute(
        _ download: WKDownload,
        _ response: URLResponse,
        _ suggestedFilename: String,
        _ webVC: SOPTWebViewControllable?
    ) async -> URL?
}

