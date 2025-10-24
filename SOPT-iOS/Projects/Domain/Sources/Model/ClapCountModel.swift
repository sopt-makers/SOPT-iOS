//
//  ClapCountModel.swift
//  Domain
//
//  Created by 최주리 on 10/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ClapCountModel {
    public let stapmId: Int
    public let appliedCount: Int
    public let totalClapCount: Int
    
    public init(stapmId: Int, appliedCount: Int, totalClapCount: Int) {
        self.stapmId = stapmId
        self.appliedCount = appliedCount
        self.totalClapCount = totalClapCount
    }
}
