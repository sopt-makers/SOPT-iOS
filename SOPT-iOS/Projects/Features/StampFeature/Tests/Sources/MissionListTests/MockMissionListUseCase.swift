//
//  MockMissionListUseCase.swift
//  StampFeatureTests
//
//  Created by Junho Lee on 2023/04/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Domain
import Core

final
class MockMissionListUseCase: MissionListUseCase {
    var fetchMissionListCalled = false
    var fetchOtherUserMissionListCalled = false
    var username = ""
    var fetchType = MissionListFetchType.all
    
    var missionListModelsFetched = PassthroughSubject<[MissionListModel], Error>()

    func fetchMissionList(type: MissionListFetchType) {
        fetchType = type
        fetchMissionListCalled = true
    }

    func fetchOtherUserMissionList(userName: String) {
        self.username = userName
        fetchOtherUserMissionListCalled = true
    }
}
