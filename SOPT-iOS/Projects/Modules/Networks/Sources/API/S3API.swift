//
//  S3API.swift
//  Networks
//
//  Created by Ian on 4/7/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

import Moya

public enum S3API {
  case getPresignedUrl
}

extension S3API: BaseAPI {
  public static var apiType: APIType = .s3

  public var path: String {
    switch self {
    case .getPresignedUrl: return "/stamp"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .getPresignedUrl: return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .getPresignedUrl: return .requestPlain
    }
  }
}
