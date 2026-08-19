//
//  AlertButton.swift
//  BaseFeatureDependency
//
//  Created by yungu0010 on 8/20/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Core
import MDS

public struct AlertButton {
    public let title: String
    public let prefixIcon: MDSIcon?
    public let suffixIcon: MDSIcon?

    public init(_ title: String, prefixIcon: MDSIcon? = nil, suffixIcon: MDSIcon? = nil) {
        self.title = title
        self.prefixIcon = prefixIcon
        self.suffixIcon = suffixIcon
    }

    public static let ok = AlertButton(I18N.Default.ok)
    public static let cancel = AlertButton(I18N.Default.cancel)
}
