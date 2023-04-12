//
//  StampService.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultStampService = BaseService<StampAPI>

public protocol StampService {
    func fetchStampListDetail(missionId: Int) -> AnyPublisher<ListDetailEntity, Error>
    func postStamp(missionId: Int, requestModel: [Any]) -> AnyPublisher<ListDetailEntity, Error>
    func putStamp(missionId: Int, requestModel: [Any]) -> AnyPublisher<StampEntity, Error>
    func deleteStamp(stampId: Int) -> AnyPublisher<Int, Error>
    func resetStamp() -> AnyPublisher<Int, Error>
}

extension DefaultStampService: StampService {
    public func fetchStampListDetail(missionId: Int) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.fetchStampListDetail(missionId: missionId))
    }
    
    public func postStamp(missionId: Int, requestModel: [Any]) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.postStamp(missionId: missionId, requestModel: requestModel))
    }
    
    public func putStamp(missionId: Int, requestModel: [Any]) -> AnyPublisher<StampEntity, Error> {
        requestObjectInCombine(StampAPI.putStamp(missionId: missionId, requestModel: requestModel))
    }
    
    public func deleteStamp(stampId: Int) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(StampAPI.deleteStamp(stampId: stampId))
    }
    
    public func resetStamp() -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(StampAPI.resetStamp)
    }
}
