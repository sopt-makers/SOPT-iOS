//
//  HotBoardTransform.swift
//  Data
//
//  Created by Aiden.lee on 7/6/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HotBoardEntity {
  public func toDomain() -> HotBoardModel {
    return HotBoardModel(title: title, content: content, url: url)
  }
}
