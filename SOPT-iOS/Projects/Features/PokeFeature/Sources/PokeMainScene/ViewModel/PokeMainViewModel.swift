//
//  PokeMainViewModel.swift
//  PokeFeature
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import PokeFeatureInterface
import BaseFeatureDependency

internal typealias UserId = Int

public class PokeMainViewModel:
    PokeMainViewModelType {
    
    public var onNaviBackTap: (() -> Void)?
    public var onPokeNotificationsTap: (() -> Void)?
    public var onMyFriendsTap: (() -> Void)?
    public var onProfileImageTapped: ((Int) -> Void)?
    public var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel)>)?
    public var onNewFriendMade: ((String) -> Void)?
    public var switchToOnboarding: (() -> Void)?
    
    // MARK: - Properties
    
    private let useCase: PokeMainUseCase
    private let isRouteFromRoot: Bool
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let pokedSectionHeaderButtonTap: Driver<Void>
        let friendSectionHeaderButtonTap: Driver<Void>
        let pokedSectionKokButtonTap: Driver<PokeUserModel?>
        let friendSectionKokButtonTap: Driver<PokeUserModel?>
        let nearbyFriendsSectionKokButtonTap: Driver<PokeUserModel?>
        let refreshRequest: Driver<Void>
        let profileImageTap: Driver<PokeUserModel?>
        let randomUserSectionFriendProfileImageTap: Driver<Int?>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let pokedToMeUser = PassthroughSubject<PokeUserModel, Never>()
        let pokedUserSectionWillBeHidden = PassthroughSubject<Bool, Never>()
        let myFriend = PassthroughSubject<PokeUserModel, Never>()
        let friendsSectionWillBeHidden = PassthroughSubject<Bool, Never>()
        let friendRandomUsers = PassthroughSubject<[PokeFriendRandomUserModel], Never>()
        let endRefreshLoading = PassthroughSubject<Void, Never>()
        let pokeResponse = PassthroughSubject<PokeUserModel, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - initialization
    
    public init(useCase: PokeMainUseCase, isRouteFromRoot: Bool = false) {
        self.useCase = useCase
        self.isRouteFromRoot = isRouteFromRoot
    }
}

extension PokeMainViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        Publishers.Merge(input.viewDidLoad, input.refreshRequest)
            .sink { [weak self] _ in
                self?.useCase.getWhoPokedToMe()
                self?.useCase.getFriend()
                self?.useCase.getFriendRandomUser()
            }.store(in: cancelBag)
        
        input.viewDidLoad
            .map { [weak self] _ in
                self?.isRouteFromRoot
            }
            .compactMap { $0 }
            .filter { $0 == true }
            .sink { [weak self] _ in
                output.isLoading.send(true)
                self?.useCase.checkPokeNewUser()
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .sink { [weak self] _ in
                self?.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.pokedSectionHeaderButtonTap
            .sink { [weak self] _ in
                self?.onPokeNotificationsTap?()
            }.store(in: cancelBag)
        
        input.friendSectionHeaderButtonTap
            .sink { [weak self] _ in
                self?.onMyFriendsTap?()
            }.store(in: cancelBag)
        
        // 답장
        input.pokedSectionKokButtonTap
            .compactMap { $0 }
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel)> in
                guard let self, let value = self.onPokeButtonTapped?(userModel) else { return .empty() }
                return value
            }
            .sink { [weak self] userModel, messageModel in
                self?.useCase.poke(userId: userModel.userId, message: messageModel, willBeNewFriend: userModel.isFirstMeet)
            }.store(in: cancelBag)
        
        // 먼저 찌르기
        input.friendSectionKokButtonTap
            .merge(with: input.nearbyFriendsSectionKokButtonTap)
            .compactMap { $0 }
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel)> in
                guard let self, let value = self.onPokeButtonTapped?(userModel) else { return .empty() }
                return value
            }
            .sink { [weak self] userModel, messageModel in
                self?.useCase.poke(userId: userModel.userId, message: messageModel, willBeNewFriend: false)
            }.store(in: cancelBag)
        
        input.profileImageTap
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.onProfileImageTapped?(user.playgroundId)
            }.store(in: cancelBag)
        
        input.randomUserSectionFriendProfileImageTap
            .compactMap { $0 }
            .sink { [weak self] playgroundId in
                self?.onProfileImageTapped?(playgroundId)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.pokedToMeUser
            .compactMap { $0 }
            .subscribe(output.pokedToMeUser)
            .store(in: cancelBag)
        
        useCase.pokedToMeUser
            .map { $0 == nil }
            .subscribe(output.pokedUserSectionWillBeHidden)
            .store(in: cancelBag)
        
        useCase.myFriend
            .compactMap { $0.first }
            .subscribe(output.myFriend)
            .store(in: cancelBag)
        
        useCase.myFriend
            .map { $0.isEmpty }
            .subscribe(output.friendsSectionWillBeHidden)
            .store(in: cancelBag)
        
        useCase.friendRandomUsers
            .prefix(2)
            .subscribe(output.friendRandomUsers)
            .store(in: cancelBag)
        
        Publishers.Zip3(useCase.pokedToMeUser, useCase.myFriend, useCase.friendRandomUsers)
            .map { _ in Void() }
            .subscribe(output.endRefreshLoading)
            .store(in: cancelBag)
        
        useCase.pokedResponse
            .subscribe(output.pokeResponse)
            .store(in: cancelBag)
        
        // 다른 뷰에서 찌르기를 했을 때 메인 뷰의 해당 유저의 찌르기 버튼을 비활성화 하기 위해 NotificationCenter로 찌르기 이벤트를 받아온다.
        let notiName = NotiList.makeNotiName(list: .pokedResponse)
        NotificationCenter.default.publisher(for: notiName)
            .compactMap { $0.object as? PokeUserModel }
            .subscribe(output.pokeResponse)
            .store(in: cancelBag)
        
        useCase.pokedResponse
            .sink { _ in
                ToastUtils.showMDSToast(type: .success, text: I18N.Poke.pokeSuccess)
            }.store(in: cancelBag)
        
        useCase.madeNewFriend
            .sink { [weak self] userModel in
                self?.onNewFriendMade?(userModel.name)
            }.store(in: cancelBag)
        
        useCase.errorMessage
            .compactMap { $0 }
            .sink { message in
                ToastUtils.showMDSToast(type: .alert, text: message)
            }.store(in: cancelBag)
        
        useCase.isPokeNewUser
            .sink { [weak self] isNewUser in
                output.isLoading.send(false)
                if isNewUser {
                    self?.switchToOnboarding?()
                }
            }.store(in: cancelBag)
    }
}
