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

import Domain

public typealias DefaultStampService = BaseService<StampAPI>

public protocol StampService {
    func fetchStampListDetail(missionId: Int, username: String) -> AnyPublisher<ListDetailEntity, Error>
    func postStamp(requestModel: ListDetailRequestModel) -> AnyPublisher<ListDetailEntity, Error>
    func putStamp(requestModel: ListDetailRequestModel) -> AnyPublisher<StampEntity, Error>
    func deleteStamp(stampId: Int) -> AnyPublisher<Int, Error>
    func resetStamp() -> AnyPublisher<Int, Error>
}

extension DefaultStampService: StampService {
    public func fetchStampListDetail(missionId: Int, username: String) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.fetchStampListDetail(missionId: missionId, username: username))
    }
    
    public func postStamp(requestModel: ListDetailRequestModel) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.postStamp(requestModel: requestModel))
    }
    
    public func putStamp( requestModel: ListDetailRequestModel) -> AnyPublisher<StampEntity, Error> {
        requestObjectInCombine(StampAPI.putStamp(requestModel: requestModel))
    }
    
    public func deleteStamp(stampId: Int) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(StampAPI.deleteStamp(stampId: stampId))
    }
    
    public func resetStamp() -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(StampAPI.resetStamp)
    }
}
