//
//  WebViewConfiguration.swift
//  BaseFeatureDependency
//
//  Created by Ian on 11/30/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import WebKit

public struct WebViewConfig {
    let javaScriptEnabled: Bool
    let allowsBackForwardNavigationGestures: Bool
    let allowsInlineMediaPlayback: Bool
    let mediaTypesRequiringUserActionForPlayback: WKAudiovisualMediaTypes
    let isScrollEnabled: Bool
    
    public init(
        javaScriptEnabled: Bool = true,
        allowsBackForwardNavigationGestures: Bool = true,
        allowsInlineMediaPlayback: Bool = true,
        mediaTypesRequiringUserActionForPlayback: WKAudiovisualMediaTypes = [],
        isScrollEnabled: Bool = true
    ) {
        self.javaScriptEnabled = javaScriptEnabled
        self.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
        self.allowsInlineMediaPlayback = allowsInlineMediaPlayback
        self.mediaTypesRequiringUserActionForPlayback = mediaTypesRequiringUserActionForPlayback
        self.isScrollEnabled = isScrollEnabled
    }
}
