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
 
    typealias UserId = String
    
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
        useCase.pokedToMeUser.sink { [weak self] pokeUserModel in
            guard let self = self else { return }
            print("모델: \(pokeUserModel)")
            let notificationListContentModel = NotificationListContentModel(avatarUrl: pokeUserModel.profileImage,
                                                                            pokeRelation: PokeRelation(rawValue: pokeUserModel.relationName) ?? .newFriend,
                                                                            name: pokeUserModel.name,
                                                                            partInfomation: pokeUserModel.part,
                                                                            description: pokeUserModel.message,
                                                                            chipInfo: self.makeChipInfo(with: pokeUserModel),
                                                                            isPoked: pokeUserModel.isAlreadyPoke,
                                                                            isFirstMeet: pokeUserModel.isFirstMeet)
            output.pokedToMeUser.send(notificationListContentModel)
        }.store(in: cancelBag)
    }
    
    private func makeChipInfo(with model: PokeUserModel) -> PokeChipView.ChipType {
        if model.isFirstMeet { // 친구가 아닌 경우
            return .acquaintance(friendname: model.mutual.first ?? "", relationCount: "\(model.mutual.count)명")
        }
        
        return .withPokeCount(relation: model.relationName, pokeCount: String(model.pokeNum))
    }
}
