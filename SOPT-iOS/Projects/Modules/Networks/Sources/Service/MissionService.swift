//
//  MissionService.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultMissionService = BaseService<MissionAPI>

public protocol MissionService {
    func fetchAllMissionList() -> AnyPublisher<MissionListEntity, Error>
    func fetchCompleteMissionList() -> AnyPublisher<MissionListEntity, Error>
    func fetchIncompleteMissionList() -> AnyPublisher<MissionListEntity, Error>
}

extension DefaultMissionService: MissionService {
    public func fetchAllMissionList() -> AnyPublisher<MissionListEntity, Error> {
        requestObjectInCombine(MissionAPI.fetchMissionList(type: .all))
    }
    
    public func fetchCompleteMissionList() -> AnyPublisher<MissionListEntity, Error> {
        let response: AnyPublisher<MissionListEntity, Error> = requestObjectInCombine(MissionAPI.fetchMissionList(type: .complete))
        return response.map { entity in
            var newEntity = entity
            return newEntity.assignCompleteFetchType(true)
        }.eraseToAnyPublisher()
    }
    
    public func fetchIncompleteMissionList() -> AnyPublisher<MissionListEntity, Error> {
        let response: AnyPublisher<MissionListEntity, Error> = requestObjectInCombine(MissionAPI.fetchMissionList(type: .incomplete))
        return response.map { entity in
            var newEntity = entity
            return newEntity.assignCompleteFetchType(false)
        }.eraseToAnyPublisher()
    }
}
