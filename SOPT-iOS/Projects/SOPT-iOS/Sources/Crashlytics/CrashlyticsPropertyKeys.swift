//
//  CrashlyticsPropertyKeys.swift
//  SOPT-iOS
//
//  Created by Jae Hyun Lee on 6/15/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

enum CrashlyticsPropertyKeys {
    // MARK: - App Info
    case appVersion
    case buildNumber
    case deviceModel
    case iOSVersion
    
    // MARK: - User Info
    case userType
    
    var key: String {
        switch self {
        case .appVersion: return "app_version"
        case .buildNumber: return "build_number"
        case .deviceModel: return "device_model"
        case .iOSVersion: return "ios_version"
        case .userType: return "user_type"
        }
    }
}

// MARK: - Default Values

extension CrashlyticsPropertyKeys {
    static var defaultValues: [String: Any] {
        [
            appVersion.key: Bundle.appVersion ?? "",
            buildNumber.key: Bundle.buildVersion ?? "",
            deviceModel.key: UIDevice.current.model,
            iOSVersion.key: UIDevice.current.systemVersion,
            userType.key: UserDefaultKeyList.Auth.getUserType().rawValue
        ]
    }
}
