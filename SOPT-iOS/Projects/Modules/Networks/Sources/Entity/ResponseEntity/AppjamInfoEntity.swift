//
//  AppjamInfoEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/9/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppjamInfoEntity: Decodable {
    public let teamNumber: String?
    public let teamName: String?
    public let isAppjamJoined: Bool
}

