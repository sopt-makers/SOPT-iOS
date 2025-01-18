//
//  HomeUseCase.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol HomeUseCase {
    var homeDescription: PassthroughSubject<HomeDescriptionModel, Never> { get set }
    var recentSchedule: PassthroughSubject<HomeRecentScheduleModel, Never> { get set }
    var groupPosts: PassthroughSubject<[HomeGroupPostModel], Never> { get set }
    
    func getHomeDescription()
    func getRecentSchedule()
    func getGroupPosts()
}

public class DefaultHomeUseCase {
    
    private let repository: HomeRepositoryInterface
    private let cancelBag = CancelBag()
    
    public var homeDescription = PassthroughSubject<HomeDescriptionModel, Never>()
    public var recentSchedule = PassthroughSubject<HomeRecentScheduleModel, Never>()
    public var groupPosts = PassthroughSubject<[HomeGroupPostModel], Never>()
    
    public init(repository: HomeRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    public func getHomeDescription() {
        repository.getHomeDescription()
            .withUnretained(self)
            .sink { event in
                print("GetHomeDescription State: \(event)")
            } receiveValue: { owner, description in
                owner.homeDescription.send(description)
            }
            .store(in: cancelBag)
    }
    
    public func getRecentSchedule() {
        repository.getRecentSchedule()
            .withUnretained(self)
            .sink { event in
                print("GetRecentSchedule State: \(event)")
            } receiveValue: { owner, schedule in
                owner.recentSchedule.send(schedule)
            }
            .store(in: cancelBag)
    }
    
    public func getGroupPosts() {
        repository.getGroupPosts()
            .withUnretained(self)
            .sink { event in
                print("GetGroupPosts State: \(event)")
            } receiveValue: { owner, posts in
                owner.groupPosts.send(posts)
            }
            .store(in: cancelBag)
    }
}
