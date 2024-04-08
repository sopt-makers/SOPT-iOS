//
//  PresignedUrlTransform.swift
//  Data
//
//  Created by Ian on 4/7/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Domain
import Networks

extension PreSignedUrlEntity {
  func toDomain() -> PresignedUrlModel {
    return PresignedUrlModel(
      preSignedURL: self.preSignedURL,
      imageURL: self.imageURL
    )
  }
}
