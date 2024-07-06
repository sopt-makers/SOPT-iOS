//
//  HotBoardModel.swift
//  Domain
//
//  Created by Aiden.lee on 7/6/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HotBoardModel {
  public let title, content, url: String

  public init(title: String, content: String, url: String) {
    self.title = title
    self.content = content
    self.url = url
  }
}
