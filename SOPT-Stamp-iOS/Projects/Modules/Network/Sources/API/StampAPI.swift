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

import Domain

public enum StampAPI {
    case fetchStampListDetail(userId: Int, missionId: Int)
    case postStamp(userId: Int, missionId: Int, requestModel: ListDetailRequestModel)
    case putStamp(userId: Int, missionId: Int, requestModel: ListDetailRequestModel)
    case deleteStamp(stampId: Int)
}

extension StampAPI: BaseAPI {
    
    public static var apiType: APIType = .stamp
    
    // MARK: - Header
    public var headers: [String : String]? {
        switch self {
        case .fetchStampListDetail(let userId, _):
            return HeaderType.userId(userId: userId).value
        case .postStamp(let userId, _, _),
                .putStamp(let userId, _, _):
            return HeaderType.multipart(userId: userId).value
        case .deleteStamp:
            return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .fetchStampListDetail(_, let missionId),
                .postStamp(_ , let missionId, _),
                .putStamp(_ , let missionId, _):
            return "/\(missionId)"
        case .deleteStamp(let stampId):
            return "/\(stampId)"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .postStamp:
            return .post
        case .putStamp:
            return .put
        case .deleteStamp:
            return .delete
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
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        case .postStamp(_ , _, let requestModel),
                .putStamp(_, _, let requestModel):
            var multipartData: [Moya.MultipartFormData] = []
            
            let fileName = (self.method == .post) ? ".jpg" : ".png"
            let mimeType = (self.method == .post) ? "image/jpeg" : "image/png"
            
            let imageData = MultipartFormData(provider: .data(requestModel.imgURL ?? Data()), name: "imgUrl", fileName: fileName, mimeType: mimeType)
            multipartData.append(imageData)
        
            do {
                let content = try JSONSerialization.data(withJSONObject: ["contents": requestModel.content], options: .withoutEscapingSlashes)
                
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
