//
//  Part.swift
//  StampFeatureInterface
//
//  Created by Aiden.lee on 2024/04/06.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum Part: String, CaseIterable {
  case plan = "기획"
  case design = "디자인"
  case web = "웹"
  case ios = "아요"
  case android = "안드"
  case server = "서버"

  public func uppercasedName() -> String {
    switch self {
    case .plan: return "PLAN"
    case .design: return "DESIGN"
    case .web: return "WEB"
    case .ios: return "IOS"
    case .android: return "ANDROID"
    case .server: return "SERVER"
    }
  }
}
