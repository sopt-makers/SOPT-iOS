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
    func fetchStampListDetail(userId: Int, missionId: Int) -> AnyPublisher<ListDetailEntity, Error>
    func postStamp(userId: Int, missionId: Int, requestModel: [Any]) -> AnyPublisher<ListDetailEntity, Error>
    func putStamp(userId: Int, missionId: Int, requestModel: [Any]) -> AnyPublisher<StampEntity, Error>
    func deleteStamp(stampId: Int) -> AnyPublisher<Int, Error>
    func resetStamp(userId: Int) -> AnyPublisher<Int, Error>
}

extension DefaultStampService: StampService {
    public func fetchStampListDetail(userId: Int, missionId: Int) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.fetchStampListDetail(userId: userId, missionId: missionId))
    }
    
    public func postStamp(userId: Int, missionId: Int, requestModel: [Any]) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.postStamp(userId: userId, missionId: missionId, requestModel: requestModel))
    }
    
    public func putStamp(userId: Int, missionId: Int, requestModel: [Any]) -> AnyPublisher<StampEntity, Error> {
        requestObjectInCombine(StampAPI.putStamp(userId: userId, missionId: missionId, requestModel: requestModel))
    }
    
    public func deleteStamp(stampId: Int) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(StampAPI.deleteStamp(stampId: stampId))
    }
    
    public func resetStamp(userId: Int) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(StampAPI.resetStamp(userId: userId))
    }
}
