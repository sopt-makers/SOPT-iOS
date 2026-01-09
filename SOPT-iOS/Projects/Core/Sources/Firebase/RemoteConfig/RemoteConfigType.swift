//
//  RemoteConfigType.swift
//  Core
//
//  Created by 강윤서 on 7/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public enum RemoteConfigKey: String {
    case forcedUpdate = "forced_update_notice_iOS"
    case optionalUpdate = "optional_update_notice_iOS"
}

public enum RemoteConfigError: Error {
    case fetchFailed
    case valueNotFound
    case decodeFailed
}
