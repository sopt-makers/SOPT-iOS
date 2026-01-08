//
//  MissionAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Core

import Alamofire
import Moya

public enum MissionAPI {
    case fetchMissionList(type: MissionListFetchType)
    case fetchAppjamMissionList
}

extension MissionAPI: BaseAPI {
    
    public static var apiType: APIType = .mission
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .fetchMissionList(let type):
            return "/\(type.path)"
        default: return ""
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
        default: break
        }
        return params
    }

    private var queryParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .fetchAppjamMissionList:
            params["teamNumber"] = ""
            params["isCompleted"] = true
        default:
            break
        }
        return params
    }

    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchAppjamMissionList:
            URLEncoding.default
        default:
            JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchAppjamMissionList:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}

extension MissionAPI {
  public var baseURL: URL {
    let base = Config.Network.baseURL
    let path: String
    switch self {
    case .fetchAppjamMissionList:
      path = "/appjamtamp/mission"
    default:
      path = "/mission"
    }
    guard let url = URL(string: base + path) else {
      fatalError("baseURL could not be configured")
    }
    return url
  }
}
