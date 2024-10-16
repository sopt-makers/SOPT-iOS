//
//  AlertVCTheme.swift
//  BaseFeatureDependency
//
//  Created by sejin on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

extension AlertVC {
    public enum AlertTheme {
        case main
        case soptamp
    }
}

extension AlertVC.AlertTheme {
    var backgroundColor: UIColor {
        switch self {
        case .main:
            return DSKitAsset.Colors.gray700.color
        case .soptamp:
            return DSKitAsset.Colors.white.color
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .main:
            return DSKitAsset.Colors.white100.color
        case .soptamp:
            return DSKitAsset.Colors.soptampGray900.color
        }
    }
    
    var descriptionColor: UIColor {
        switch self {
        case .main:
            return DSKitAsset.Colors.gray30.color
        case .soptamp:
            return DSKitAsset.Colors.soptampGray500.color
        }
    }
    
    var customButtonColor: UIColor {
        switch self {
        case .main:
            return DSKitAsset.Colors.white100.color
        case .soptamp:
            return DSKitAsset.Colors.soptampError200.color
        }
    }
    
    var customButtonTitleColor: UIColor {
        switch self {
        case .main:
            return DSKitAsset.Colors.black100.color
        case .soptamp:
            return DSKitAsset.Colors.gray10.color
        }
    }
    
    func cancelButtonColor(isNetworkErr: Bool) -> UIColor {
        switch self {
        case .main:
            return isNetworkErr ? DSKitAsset.Colors.white100.color : DSKitAsset.Colors.gray600.color
        case .soptamp:
            return isNetworkErr ? DSKitAsset.Colors.black60.color : DSKitAsset.Colors.soptampGray300.color
        }
    }
    
    func cancelButtonTitleColor(isNetworkErr: Bool) -> UIColor {
        switch self {
        case .main:
            return isNetworkErr ? DSKitAsset.Colors.black100.color : DSKitAsset.Colors.white100.color
        case .soptamp:
            return isNetworkErr ? DSKitAsset.Colors.white.color : DSKitAsset.Colors.black100.color
        }
    }
}
