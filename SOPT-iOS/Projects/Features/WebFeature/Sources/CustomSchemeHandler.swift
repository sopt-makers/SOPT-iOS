//
//  CustomSchemeHandler.swift
//  WebFeature
//
//  Created by SOPT-iOS on 2025/01/15.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

/// 웹뷰에서 커스텀 URL 스킴을 처리하는 핸들러입니다.
public final class CustomSchemeHandler {
    
    // MARK: - Constants
    
    private enum SchemeType: String {
        case notion
        case nmap
        
        var appStoreURL: String? {
            switch self {
            case .notion:
                return ExternalURL.AppStore.notionApp
            case .nmap:
                return ExternalURL.AppStore.naverMapApp
            }
        }
    }
    
    private let standardSchemes = ["http", "https", "about", "file"]
    
    // MARK: - Public Methods
    
    /// URL이 커스텀 스킴인지 확인
    /// - Parameter url: 확인할 URL
    /// - Returns: 커스텀 스킴이면 true, 표준 웹 프로토콜이면 false를 반환합니다.
    public func shouldHandle(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased() else { return false }
        return !standardSchemes.contains(scheme)
    }
    
    /// 커스텀 스킴 URL 처리
    /// - Parameter url: 처리할 URL
    public func handle(_ url: URL) {
        guard let scheme = url.scheme?.lowercased() else { return }
        
        // 앱이 설치되어 있으면 해당 앱으로 열기
        if UIApplication.shared.canOpenURL(url) {
            openExternalApp(url)
            return
        }
        
        // 앱이 설치되지 않은 경우 처리
        handleUnavailableApp(for: scheme)
    }
    
    // MARK: - Private Methods
    
    /// 외부 앱 열기
    private func openExternalApp(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    /// 앱이 설치되지 않은 경우 처리
    private func handleUnavailableApp(for scheme: String) {
        guard let schemeType = SchemeType(rawValue: scheme),
              let appStoreURLString = schemeType.appStoreURL,
              let appStoreURL = URL(string: appStoreURLString) else {
            return
        }
        
        openExternalApp(appStoreURL)
    }
}

