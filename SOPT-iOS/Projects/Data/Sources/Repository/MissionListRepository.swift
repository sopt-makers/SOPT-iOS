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
import Networks

public class MissionListRepository {
  
  private let missionService: MissionService
  private let rankService: RankService
  private let userService: UserService
  private let cancelBag = CancelBag()
  
  public init(
    missionService: MissionService,
    rankService: RankService,
    userService: UserService
  ) {
    self.missionService = missionService
    self.rankService = rankService
    self.userService = userService
  }
}

extension MissionListRepository: MissionListRepositoryInterface {
  public func fetchMissionList(type: MissionListFetchType, userName: String?) -> AnyPublisher<[MissionListModel], Error> {
    guard let userName else {
      return fetchMissionList(type: type)
    }
    
    return fetchRankDetail(userName: userName)
  }
  
  public func fetchIsActiveGenerationUser() -> AnyPublisher<UsersActiveGenerationStatusViewResponse, Error> {
    self.userService
      .fetchActiveGenerationStatus()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  public func fetchCurrentSoptampInfo() -> AnyPublisher<SoptampUserModel, Error> {
    self.userService
      .fetchSoptampUser()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
}

extension MissionListRepository {
  private func fetchMissionList(type: MissionListFetchType) -> AnyPublisher<[MissionListModel], Error> {
    switch type {
    case .all:
      return missionService.fetchAllMissionList()
        .map { $0.toDomain() }
        .eraseToAnyPublisher()
    case .complete:
      return missionService.fetchCompleteMissionList()
        .map { $0.toDomain() }
        .eraseToAnyPublisher()
    case .incomplete:
      return missionService.fetchIncompleteMissionList()
        .map { $0.toDomain() }
        .eraseToAnyPublisher()
    }
  }
  
  private func fetchRankDetail(userName: String) -> AnyPublisher<[MissionListModel], Error> {
    rankService.fetchRankDetail(userName: userName)
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
}
