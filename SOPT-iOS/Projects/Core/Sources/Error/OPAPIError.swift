//
//  OPAPIError.swift
//  Core
//
//  Created by 김영인 on 2023/04/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct OPErrorResponse: Decodable {
    public let success: Bool
    public let message: String
}

public enum OPAPIError: LocalizedError {
    case attendanceError(OPErrorResponse)
    
    public var errorDescription: String? {
        switch self {
        case let .attendanceError(error):
            return String(error.message.split(separator: ": ").last ?? "")
        }
    }
}
