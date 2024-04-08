//
//  PreSignedUrlEntity.swift
//  Networks
//
//  Created by Ian on 4/7/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PreSignedUrlEntity {
  public let preSignedURL: String
  public let imageURL: String
}

extension PreSignedUrlEntity: Decodable {
  enum CodingKeys: String, CodingKey {
    case preSignedURL, imageURL
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.preSignedURL = try container.decode(String.self, forKey: .preSignedURL)
    self.imageURL = try container.decode(String.self, forKey: .imageURL)
  }
}
