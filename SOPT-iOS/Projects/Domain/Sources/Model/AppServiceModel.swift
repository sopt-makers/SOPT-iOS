//
//  AppServiceModel.swift
//  Domain
//
//  Created by Aiden.lee on 2024/06/08.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppServiceModel {
  public let serviceName: String
  public let activeUser, inactiveUser: Bool

  public init(serviceName: String, activeUser: Bool, inactiveUser: Bool) {
    self.serviceName = serviceName
    self.activeUser = activeUser
    self.inactiveUser = inactiveUser
  }
}
