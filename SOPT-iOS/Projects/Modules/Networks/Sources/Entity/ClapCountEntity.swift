//
//  ClapCountEntity.swift
//  Networks
//
//  Created by 최주리 on 10/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ClapCountEntity: Decodable {
    public let stampId: Int
    public let appliedCount: Int
    public let totalClapCount: Int
}
