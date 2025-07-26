//
//  BaseAPI.swift
//  Network
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Moya

import Core

public enum APIType {
  case attendance
  case auth
  case mission
  case rank
  case stamp
  case user
  case firebase
  case config
  case notification
  case description
  case poke
  case s3
  case fortune
  case coreAuth
  case social
  case home
  case calendar
}

public protocol BaseAPI: TargetType, AccessTokenAuthorizable {
  static var apiType: APIType { get set }
}

extension BaseAPI {
    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}

extension BaseAPI {
  public var baseURL: URL {
    var base = Config.Network.baseURL
    let operationBaseURL = Config.Network.operationBaseURL
    let coreAuthBaseURL = Config.Network.coreAuthBaseURL
      
    switch Self.apiType {
    case .attendance:
      base = operationBaseURL
    case .auth:
      base += "/auth"
    case .mission:
      base += "/mission"
    case .rank:
      base += "/rank"
    case .stamp:
      base += "/stamp"
    case .user:
      base += "/user"
    case .firebase:
      base += "/firebase"
    case .config:
      base += "/config"
    case .notification:
      base += "/notification"
    case .description:
      base += "/description"
    case .poke:
      base += "/poke"
    case .s3:
      base += "/s3"
    case .fortune:
      base += "/fortune"
    case .coreAuth:
      base = coreAuthBaseURL + "/auth"
    case .social:
      base = coreAuthBaseURL + "/social"
    case .home:
      base += "/home"
    case .calendar:
      base += "/calendar"
    }
    
    guard let url = URL(string: base) else {
      fatalError("baseURL could not be configured")
    }
    
    return url
  }
  
  public var headers: [String: String]? {
    return HeaderType.jsonWithToken.value
  }
  
  public var validationType: ValidationType {
    return .customCodes(Array(200..<600).filter { $0 != 401 })
  }
}


public enum HeaderType {
  case json
  case jsonWithToken
  case multipartWithToken
  
  public var value: [String: String] {
    switch self {
    case .json:
      return ["Content-Type": "application/json"]
    case .jsonWithToken:
      return ["Content-Type": "application/json",
              "Authorization": UserDefaultKeyList.Auth.appAccessToken ?? ""]
    case .multipartWithToken:
      return ["Content-Type": "multipart/form-data",
              "Authorization": UserDefaultKeyList.Auth.appAccessToken ?? ""]
    }
  }
}
