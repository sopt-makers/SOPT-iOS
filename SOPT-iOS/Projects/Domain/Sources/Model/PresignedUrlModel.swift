//
//  PresignedUrlModel.swift
//  Domain
//
//  Created by Ian on 4/7/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PresignedUrlModel {
  public let preSignedURL: String
  public let imageURL: String

  public init(
    preSignedURL: String,
    imageURL: String
  ) {
    self.preSignedURL = preSignedURL
    self.imageURL = imageURL
  }
}
