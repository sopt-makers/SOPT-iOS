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
    func fetchAllMissionList(userId: Int) -> AnyPublisher<MissionListEntity, Error>
    func fetchCompleteMissionList(userId: Int) -> AnyPublisher<MissionListEntity, Error>
    func fetchIncompleteMissionList(userId: Int) -> AnyPublisher<MissionListEntity, Error>
}

extension DefaultMissionService: MissionService {
    public func fetchAllMissionList(userId: Int) -> AnyPublisher<MissionListEntity, Error> {
        requestObjectInCombine(MissionAPI.fetchMissionList(type: .all, userId: userId))
    }
    
    public func fetchCompleteMissionList(userId: Int) -> AnyPublisher<MissionListEntity, Error> {
        requestObjectInCombine(MissionAPI.fetchMissionList(type: .complete, userId: userId))
    }
    
    public func fetchIncompleteMissionList(userId: Int) -> AnyPublisher<MissionListEntity, Error> {
        requestObjectInCombine(MissionAPI.fetchMissionList(type: .incomplete, userId: userId))
    }
}
