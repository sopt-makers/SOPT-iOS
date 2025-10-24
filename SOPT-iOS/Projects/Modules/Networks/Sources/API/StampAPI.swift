//
//  StampAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum StampAPI {
  case fetchStampListDetail(missionId: Int, username: String)
  case postStamp(requestModel: ListDetailRequestEntity)
  case putStamp(requestModel: ListDetailRequestEntity)
  case deleteStamp(stampId: Int)
  case resetStamp
  case getReportUrl
  case clap(stampId: Int, clapCount: Int)
}

extension StampAPI: BaseAPI {
  
  public static var apiType: APIType = .stamp

  // MARK: - Path
  public var path: String {
    switch self {
    case .fetchStampListDetail:
      return ""
    case .postStamp, .putStamp:
      return ""
    case .deleteStamp(let stampId):
      return "/\(stampId)"
    case .resetStamp:
      return "/all"
    case .getReportUrl:
      return "/report"
    case .clap(let stampId, _):
      return "/\(stampId)/clap"
    }
  }
  
  // MARK: - Method
  public var method: Moya.Method {
    switch self {
    case .postStamp, .clap:
      return .post
    case .putStamp:
      return .put
    case .deleteStamp, .resetStamp:
      return .delete
    default: return .get
    }
  }
  
  // MARK: - Parameters
  private var bodyParameters: Parameters? {
    var params: Parameters = [:]
    switch self {
    case .fetchStampListDetail(let missionId, let username):
      params["missionId"] = missionId
      params["nickname"] = username
    case .putStamp(let requestModel), .postStamp(let requestModel):
      params["missionId"] = requestModel.missionId
      params["image"] = requestModel.imgURL
      params["contents"] = requestModel.content
      params["activityDate"] = requestModel.activityDate
    case .clap(_, let clapCount):
        params["clapCount"] = clapCount
    default: break
    }
    return params
  }
  
  private var parameterEncoding: ParameterEncoding {
    switch self {
    case .fetchStampListDetail:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
  
  public var task: Task {
    switch self {
    case .fetchStampListDetail, .postStamp, .putStamp:
      return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
    default:
      return .requestPlain
    }
  }
}
