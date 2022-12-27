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
    func fetchStampListDetail(userId: Int, missionId: Int) -> AnyPublisher<ListDetailEntity, Error>
    func postStamp(userId: Int, missionId: Int, requestModel: ListDetailRequestModel) -> AnyPublisher<ListDetailEntity, Error>
    func putStamp(userId: Int, missionId: Int, requestModel: ListDetailRequestModel) -> AnyPublisher<StampEntity, Error>
}

extension DefaultStampService: StampService {
    public func fetchStampListDetail(userId: Int, missionId: Int) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.fetchStampListDetail(userId: userId, missionId: missionId))
    }
    
    public func postStamp(userId: Int, missionId: Int, requestModel: ListDetailRequestModel) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.postStamp(userId: userId, missionId: missionId, requestModel: requestModel))
    }
    
    public func putStamp(userId: Int, missionId: Int, requestModel: ListDetailRequestModel) -> AnyPublisher<StampEntity, Error> {
        requestObjectInCombine(StampAPI.putStamp(userId: userId, missionId: missionId, requestModel: requestModel))
    }
}
