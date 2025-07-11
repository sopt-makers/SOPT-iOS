//
//  NSBundle+.swift
//  Core
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public enum BundleKey: String {
    case appVersion = "CFBundleShortVersionString"
    case buildVersion = "CFBundleVersion"
    case appId = "AppID"
}

public extension Bundle {
    static func getValue<T>(for key: BundleKey, as type: T.Type) -> T? {
        return Bundle.main.infoDictionary?[key.rawValue] as? T
    }
    static var appVersion: String? {
        return getValue(for: .appVersion, as: String.self)
    }
    
    static var buildVersion: String? {
        return getValue(for: .buildVersion, as: String.self)
    }
    
    static var appId: String? {
        return getValue(for: .appId, as: String.self)
    }
}
