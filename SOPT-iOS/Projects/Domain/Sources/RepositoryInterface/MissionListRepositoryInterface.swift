//
//  MissionListRepositoryInterface.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public protocol MissionListRepositoryInterface {
  func fetchMissionList(type: MissionListFetchType, userName: String?) -> AnyPublisher<[MissionListModel], Error>
  func fetchIsActiveGenerationUser() -> AnyPublisher<UsersActiveGenerationStatusViewResponse, Error>
  func fetchCurrentSoptampInfo() -> AnyPublisher<SoptampUserModel, Error>
  func getReportUrl() -> AnyPublisher<SoptampReportUrlModel, Error>
}
