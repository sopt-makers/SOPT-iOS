//
//  RankAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum RankAPI {
  case rank
  case currentRank
  case rankDetail(userName: String)
  case rankPart
  case currentRankInPart(partName: String)
}

extension RankAPI: BaseAPI {

  public static var apiType: APIType = .rank

  // MARK: - Header
  public var headers: [String: String]? {
    switch self {
    default:
      return HeaderType.jsonWithToken.value
    }
  }

  // MARK: - Path
  public var path: String {
    switch self {
    case .rank:
      return ""
    case .currentRank:
      return "/current"
    case .rankDetail:
      return "/detail"
    case .rankPart:
      return "/part"
    case .currentRankInPart(let partName):
      return "/current/part/\(partName)"
    }
  }

  // MARK: - Method
  public var method: Moya.Method {
    switch self {
    default: return .get
    }
  }

  // MARK: - Parameters
  private var bodyParameters: Parameters? {
    var params: Parameters = [:]
    switch self {
    case .rankDetail(let userName):
      params["nickname"] = userName
    default: break
    }
    return params
  }

  private var parameterEncoding: ParameterEncoding {
    switch self {
    case .rankDetail:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }

  public var task: Task {
    switch self {
    case .rankDetail:
      return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
    default:
      return .requestPlain
    }
  }
}
