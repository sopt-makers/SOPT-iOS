//
//  AppServiceEntity.swift
//  Networks
//
//  Created by Aiden.lee on 2024/06/08.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppServiceEntity: Decodable {
  public let serviceName: String
  public let activeUser, inactiveUser: Bool
}
