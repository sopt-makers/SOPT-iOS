//
//  S3Service.swift
//  Networks
//
//  Created by Ian on 4/7/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya

public typealias DefaultS3Service = BaseService<S3API>

public protocol S3Service {
  func getPresignedUrl() -> AnyPublisher<PreSignedUrlEntity, Error>
}

extension DefaultS3Service: S3Service {
  public func getPresignedUrl() -> AnyPublisher<PreSignedUrlEntity, Error> {
    requestObjectInCombine(.getPresignedUrl)
  }
}
