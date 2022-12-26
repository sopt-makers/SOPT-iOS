//
//  SignInTransform.swift
//  Data
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

extension SignInEntity {

    public func toDomain() -> SignInModel {
        return SignInModel.init(userId: self.userId, message: self.message)
    }
}
