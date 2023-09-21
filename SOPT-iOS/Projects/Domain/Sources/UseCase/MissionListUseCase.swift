//
//  MissionListUseCase.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public protocol MissionListUseCase {
    func fetchMissionList(type: MissionListFetchType)
    func fetchOtherUserMissionList(userName: String)
    func fetchIsActiveGenerationUser()

    var missionListModelsFetched: PassthroughSubject<[MissionListModel], Error> { get set }
    var usersActiveGenerationInfo: PassthroughSubject<UsersActiveGenerationStatusViewResponse, Error> { get set }
}

public class DefaultMissionListUseCase {
  
    private let repository: MissionListRepositoryInterface
    private var cancelBag = CancelBag()
    public var missionListModelsFetched = PassthroughSubject<[MissionListModel], Error>()
    public var usersActiveGenerationInfo = PassthroughSubject<UsersActiveGenerationStatusViewResponse, Error>()
    
    public init(repository: MissionListRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultMissionListUseCase: MissionListUseCase {
    public func fetchMissionList(type: MissionListFetchType) {
        repository.fetchMissionList(type: type, userName: nil)
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { model in
                self.missionListModelsFetched.send(model)
            })
            .store(in: cancelBag)
    }
    
    public func fetchIsActiveGenerationUser() {
        self.repository
            .fetchIsActiveGenerationUser()
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { usersActiveGenerationStatus in
                self.usersActiveGenerationInfo.send(usersActiveGenerationStatus)
            }).store(in: self.cancelBag)
    }
    
    public func fetchOtherUserMissionList(userName: String) {
        repository.fetchMissionList(type: .complete, userName: userName)
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { model in
                self.missionListModelsFetched.send(model)
            })
            .store(in: cancelBag)
    }
}
