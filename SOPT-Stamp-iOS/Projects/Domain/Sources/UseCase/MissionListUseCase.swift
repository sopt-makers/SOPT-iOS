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
    func fetchOtherUserMissionList(type: MissionListFetchType, userId: Int)
    var missionListModelsFetched: PassthroughSubject<[MissionListModel], Error> { get set }
}

public class DefaultMissionListUseCase {
  
    private let repository: MissionListRepositoryInterface
    private var cancelBag = CancelBag()
    public var missionListModelsFetched = PassthroughSubject<[MissionListModel], Error>()
  
    public init(repository: MissionListRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultMissionListUseCase: MissionListUseCase {
    public func fetchOtherUserMissionList(type: MissionListFetchType, userId: Int) {
        repository.fetchMissionList(type: type, userId: userId)
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { model in
                self.missionListModelsFetched.send(model)
            })
            .store(in: cancelBag)
    }
    
    public func fetchMissionList(type: MissionListFetchType) {
        repository.fetchMissionList(type: type, userId: nil)
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { model in
                self.missionListModelsFetched.send(model)
            })
            .store(in: cancelBag)
    }
}
