//
//  BaseEntity.swift
//  Network
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct BaseEntity<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    public let data: T?
}
