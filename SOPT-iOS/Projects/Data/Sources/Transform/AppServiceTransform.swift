//
//  AppServiceTransform.swift
//  Data
//
//  Created by Aiden.lee on 2024/06/08.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Networks
import Domain

public extension AppServiceEntity {
  func toDomain() -> AppServiceModel {
    return .init(serviceName: serviceName, activeUser: activeUser, inactiveUser: inactiveUser)
  }
}
