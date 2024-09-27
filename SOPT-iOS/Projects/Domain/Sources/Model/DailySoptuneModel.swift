//
//  DailySoptuneModel.swift
//  Domain
//
//  Created by 강윤서 on 9/27/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct DailySoptuneResultModel: Codable {
    public let userName: String
    public let title: String
    
    public init(userName: String, title: String) {
        self.userName = userName
        self.title = title
    }
}
