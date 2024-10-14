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

import Core

public typealias DefaultStampService = BaseService<StampAPI>

public protocol StampService {
    func fetchStampListDetail(missionId: Int, username: String) -> AnyPublisher<ListDetailEntity, Error>
    func postStamp(requestModel: ListDetailRequestEntity) -> AnyPublisher<ListDetailEntity, Error>
    func putStamp(requestModel: ListDetailRequestEntity) -> AnyPublisher<StampEntity, Error>
    func deleteStamp(stampId: Int) -> AnyPublisher<Int, Error>
    func resetStamp() -> AnyPublisher<Int, Error>
    func getReportUrl() -> AnyPublisher<SoptampReportUrlEntity, Error>
}

extension DefaultStampService: StampService {
    public func fetchStampListDetail(missionId: Int, username: String) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.fetchStampListDetail(missionId: missionId, username: username))
    }
    
    public func postStamp(requestModel: ListDetailRequestEntity) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.postStamp(requestModel: requestModel))
    }
    
    public func putStamp( requestModel: ListDetailRequestEntity) -> AnyPublisher<StampEntity, Error> {
        requestObjectInCombine(StampAPI.putStamp(requestModel: requestModel))
    }
    
    public func deleteStamp(stampId: Int) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(StampAPI.deleteStamp(stampId: stampId))
    }
    
    public func resetStamp() -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(StampAPI.resetStamp)
    }
    
    public func getReportUrl() -> AnyPublisher<SoptampReportUrlEntity, Error> {
        return requestObjectInCombine(StampAPI.getReportUrl)
    }
}
