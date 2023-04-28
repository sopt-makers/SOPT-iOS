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

public enum StampAPI {
    case fetchStampListDetail(missionId: Int, username: String)
    case postStamp(missionId: Int, requestModel: [Any])
    case putStamp(missionId: Int, requestModel: [Any])
    case deleteStamp(stampId: Int)
    case resetStamp
}

extension StampAPI: BaseAPI {
    
    public static var apiType: APIType = .stamp
    
    // MARK: - Header
    public var headers: [String : String]? {
        switch self {
        case .fetchStampListDetail, .resetStamp:
            return HeaderType.jsonWithToken.value
        case .postStamp, .putStamp:
            return HeaderType.multipartWithToken.value
        case .deleteStamp:
            return HeaderType.jsonWithToken.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .fetchStampListDetail:
            return ""
        case .postStamp(let missionId, _),
                .putStamp(let missionId, _):
            return "/\(missionId)"
        case .deleteStamp(let stampId):
            return "/\(stampId)"
        case .resetStamp:
            return "/all"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .postStamp:
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
        case .fetchStampListDetail:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        case .postStamp(_, let requestModel), .putStamp(_, let requestModel):
            var multipartData: [Moya.MultipartFormData] = []
            
            let fileName = (self.method == .post) ? ".jpg" : ".png"
            let mimeType = (self.method == .post) ? "image/jpeg" : "image/png"
            
            let imageData = MultipartFormData(provider: .data(requestModel[0] as! Data), name: "imgUrl", fileName: fileName, mimeType: mimeType)
            multipartData.append(imageData)
        
            do {
                let content = try JSONSerialization.data(withJSONObject: ["contents": requestModel[1]], options: .withoutEscapingSlashes)
                
                let formData = MultipartFormData(provider: .data(content), name: "stampContent", mimeType: "application/json")
                multipartData.append(formData)
            } catch {
                print(error.localizedDescription)
            }
            
            return .uploadMultipart(multipartData)
        default:
            return .requestPlain
        }
    }
}
