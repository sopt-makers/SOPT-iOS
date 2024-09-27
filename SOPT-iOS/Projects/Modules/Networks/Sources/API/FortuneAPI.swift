//
//  FortuneAPI.swift
//  Networks
//
//  Created by 강윤서 on 9/27/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum FortuneAPI {
    case getTodayFortune(date: String)
}

extension FortuneAPI: BaseAPI {
	public static var apiType: APIType = .fortune
	
	public var path: String {
        switch self {
        case .getTodayFortune:
            return "/word"
        }
	}
	
	public var method: Moya.Method {
        switch self {
        case .getTodayFortune:
            return .get
        }
	}
	
	public var task: Moya.Task {
        switch self {
        case .getTodayFortune(let date):
            return .requestParameters(parameters: ["todayDate": date], encoding: URLEncoding.queryString)
        }
	}
}
