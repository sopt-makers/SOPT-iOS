//
//  PokedToMeHistoryListEntity.swift
//  Networks
//
//  Created by Ian on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokedToMeHistoryListEntity: Decodable {
    public let history: [PokeUserEntity]
    public let pageSize: Int
    public let pageNum: Int
}
