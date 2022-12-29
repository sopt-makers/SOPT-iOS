//
//  SignInModel.swift
//  Domain
//
//  Created by devxsby on 2022/12/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct SignInModel {
    let userId: Int?
    let message: String?
    
    public init(userId: Int?, message: String?) {
        self.userId = userId
        self.message = message
    }
}
