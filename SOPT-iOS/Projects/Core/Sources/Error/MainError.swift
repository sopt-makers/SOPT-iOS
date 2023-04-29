//
//  MainError.swift
//  Core
//
//  Created by sejin on 2023/04/29.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum MainError: Error {
    case networkError
    case unregisteredUser // 플그 미동록 유저
    case authFailed // 토큰 재발급 실패 등 인증 에러
}
