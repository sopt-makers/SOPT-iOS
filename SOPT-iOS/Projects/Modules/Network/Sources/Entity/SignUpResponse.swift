//
//  SignUpResponse.swift
//  Network
//
//  Created by Junho Lee on 2023/01/13.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct SignUpResponse: Codable {
    public let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
}
