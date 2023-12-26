//
//  PokeError.swift
//  Domain
//
//  Created by sejin on 12/26/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum PokeError: Error {
    case exceedTodayPokeCount(message: String)
    case duplicatePoke(message: String)
    case unknown(message: String)
    case networkError
}

public extension PokeError {
    var toastMessage: String? {
        switch self {
        case .exceedTodayPokeCount(let message):
            return message
        case .duplicatePoke(let message):
            return message
        default:
            return "콕 찌르기 실패"
        }
    }
}
