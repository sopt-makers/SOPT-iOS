//
//  ClapCountModel.swift
//  Domain
//
//  Created by 최주리 on 10/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ClapCountModel {
    public let stampId: Int
    public let appliedCount: Int
    public let totalClapCount: Int
    
    public init(stampId: Int, appliedCount: Int, totalClapCount: Int) {
        self.stampId = stampId
        self.appliedCount = appliedCount
        self.totalClapCount = totalClapCount
    }
}
