//
//  NSBundle+.swift
//  Core
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public extension Bundle {
    static var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    static var buildVersion: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}
