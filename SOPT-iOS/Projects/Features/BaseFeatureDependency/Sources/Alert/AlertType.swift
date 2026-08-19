//
//  AlertType.swift
//  Core
//
//  Created by 김영인 on 2023/03/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import MDS

public enum AlertType {
    case `default`(primary: AlertButton, secondary: AlertButton = .cancel)
    case information(primary: AlertButton = .ok)
    case danger(primary: AlertButton, secondary: AlertButton = .cancel)

    public var mdsVariant: MDSDialog.Variant {
        switch self {
        case let .default(primary, secondary):
            return .default(
                primaryButtonTitle: primary.title,
                primaryButtonPrefixIcon: primary.prefixIcon,
                primaryButtonSuffixIcon: primary.suffixIcon,
                secondaryButtonTitle: secondary.title,
                secondaryButtonPrefixIcon: secondary.prefixIcon,
                secondaryButtonSuffixIcon: secondary.suffixIcon
            )
        case let .information(primary):
            return .information(
                primaryButtonTitle: primary.title,
                primaryButtonPrefixIcon: primary.prefixIcon,
                primaryButtonSuffixIcon: primary.suffixIcon
            )
        case let .danger(primary, secondary):
            return .danger(
                primaryButtonTitle: primary.title,
                primaryButtonPrefixIcon: primary.prefixIcon,
                primaryButtonSuffixIcon: primary.suffixIcon,
                secondaryButtonTitle: secondary.title,
                secondaryButtonPrefixIcon: secondary.prefixIcon,
                secondaryButtonSuffixIcon: secondary.suffixIcon
            )
        }
    }
}
