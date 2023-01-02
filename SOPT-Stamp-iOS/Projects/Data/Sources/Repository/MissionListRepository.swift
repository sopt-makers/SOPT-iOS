//
//  MissionListRepository.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class MissionListRepository {
    
    private let missionService: MissionService
    private let cancelBag = CancelBag()
    
    public init(service: MissionService) {
        self.missionService = service
    }
}

extension MissionListRepository: MissionListRepositoryInterface {
    public func fetchMissionList(type: MissionListFetchType, userId: Int?) -> AnyPublisher<[MissionListModel], Error> {
        let userId = userId ?? 1
        switch type {
        case .all:
            return missionService.fetchAllMissionList(userId: userId)
                .map { $0.toDomain() }
                .eraseToAnyPublisher()
        case .complete:
            return missionService.fetchCompleteMissionList(userId: userId)
                .map { $0.toDomain() }
                .eraseToAnyPublisher()
        case .incomplete:
            return missionService.fetchIncompleteMissionList(userId: userId)
                .map { $0.toDomain() }
                .eraseToAnyPublisher()
        }
    }
}
