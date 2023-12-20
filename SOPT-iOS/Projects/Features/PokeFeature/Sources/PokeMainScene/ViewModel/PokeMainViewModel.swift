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

public class PokeMainViewModel:
    PokeMainViewModelType {
    
    typealias UserId = Int
    
    public var onNaviBackTap: (() -> Void)?
    public var onMyFriendsTap: (() -> Void)?
    
    // MARK: - Properties
    
    private let useCase: PokeMainUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let pokedSectionHeaderButtonTap: Driver<Void>
        let friendSectionHeaderButtonTap: Driver<Void>
        let pokedSectionKokButtonTap: Driver<UserId?>
        let friendSectionKokButtonTap: Driver<UserId?>
        let nearbyFriendsSectionKokButtonTap: Driver<UserId?>
        let refreshRequest: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let pokedToMeUser = PassthroughSubject<NotificationListContentModel, Never>()
        let pokedUserSectionWillBeHidden = PassthroughSubject<Bool, Never>()
        let myFriend = PassthroughSubject<PokeUserModel, Never>()
        let friendsSectionWillBeHidden = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - initialization
    
    public init(useCase: PokeMainUseCase) {
        self.useCase = useCase
    }
}

extension PokeMainViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .sink { [weak self] _ in
                self?.useCase.getWhoPokedToMe()
                self?.useCase.getFriend()
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .sink { [weak self] _ in
                self?.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.pokedSectionHeaderButtonTap
            .sink { _ in
                print("찌르기 알림 뷰로 이동")
            }.store(in: cancelBag)
        
        input.friendSectionHeaderButtonTap
            .sink { [weak self] _ in
                self?.onMyFriendsTap?()
            }.store(in: cancelBag)
        
        input.pokedSectionKokButtonTap
            .compactMap { $0 }
            .sink { userId in
                print("찌르기 - \(userId)")
            }.store(in: cancelBag)
        
        input.friendSectionKokButtonTap
            .compactMap { $0 }
            .sink { userId in
                print("찌르기 - \(userId)")
            }.store(in: cancelBag)
        
        input.nearbyFriendsSectionKokButtonTap
            .compactMap { $0 }
            .sink { userId in
                print("찌르기 - \(userId)")
            }.store(in: cancelBag)
        
        input.refreshRequest
            .sink { _ in
                print("리프레시 요청")
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.pokedToMeUser
            .compactMap { $0 }
            .withUnretained(self)
            .map { owner, pokeUserModel in
                owner.makeNotificationListContentModel(with: pokeUserModel)
            }
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
    }
}

// MARK: - Methods

extension PokeMainViewModel {
    private func makeNotificationListContentModel(with model: PokeUserModel) -> NotificationListContentModel {
        return NotificationListContentModel(userId: model.userId,
                                            avatarUrl: model.profileImage,
                                            pokeRelation: PokeRelation(rawValue: model.relationName) ?? .newFriend,
                                            name: model.name,
                                            partInfomation: model.part,
                                            description: model.message,
                                            chipInfo: self.makeChipInfo(with: model),
                                            isPoked: model.isAlreadyPoke,
                                            isFirstMeet: model.isFirstMeet)
    }
    
    private func makeChipInfo(with model: PokeUserModel) -> PokeChipView.ChipType {
        if model.isFirstMeet { // 친구가 아닌 경우
            switch model.mutual.count {
            case 0:
                return .newUser
            case 1:
                return .singleFriend(friendName: model.mutual.first ?? "")
            default:
                return .acquaintance(friendname: model.mutual.first ?? "", relationCount: "\(model.mutual.count-1)명")
            }
        }
        
        return .withPokeCount(relation: model.relationName, pokeCount: String(model.pokeNum))
    }
}
