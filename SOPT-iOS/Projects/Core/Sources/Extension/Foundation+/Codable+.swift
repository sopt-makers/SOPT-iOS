//
//  Codable+.swift
//  Core
//
//  Created by Ian on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

extension Encodable {
  public func toDictionary() -> [String: Any] {
    let jsonEncoder = JSONEncoder()

    guard
      let jsonData = try? jsonEncoder.encode(self),
      let result = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
    else { return [:] }

    return result.compactMapValues { $0 is NSNull ? nil : $0 }
  }
}
