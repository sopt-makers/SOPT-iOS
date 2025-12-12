//
//  PokeBuilder.swift
//  PokeFeatureInterface
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency
@_exported import PokeFeatureInterface

public final class PokeBuilder {
    @Injected public var pokeMainRepository: PokeMainRepositoryInterface
    @Injected public var pokeMyFriendsRepository: PokeMyFriendsRepositoryInterface
    @Injected public var pokeOnboardingRepository: PokeOnboardingRepositoryInterface
    @Injected public var pokeNotificationListRepository: PokeNotificationRepositoryInterface
   
    public init() {}
}

extension PokeBuilder: PokeFeatureBuildable {
    public func makePokeOnboarding() -> PokeFeatureInterface.PokeOnboardingPresentable {
        let usecase = DefaultPokeOnboardingUsecase(repository: self.pokeOnboardingRepository)
        let viewModel = PokeOnboardingViewModel(usecase: usecase)
        let viewController = PokeOnboardingVC(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
    
    public func makePokeMain(isRouteFromRoot: Bool, isRouteFromTabBar: Bool, coordinator: Coordinator) -> PokeFeatureInterface.PokeMainPresentable {
        let useCase = DefaultPokeMainUseCase(repository: pokeMainRepository)
        let viewModel = PokeMainViewModel(useCase: useCase,
                                          coordinator: coordinator,
                                          isRouteFromRoot: isRouteFromRoot)
        let pokeMainVC = PokeMainVC(viewModel: viewModel, isRouteFromTabBar: isRouteFromTabBar)
        
        return (pokeMainVC, viewModel)
    }
    
    public func makePokeMyFriends(coordinator: Coordinator) -> PokeFeatureInterface.PokeMyFriendsPresentable {
        let useCase = DefaultPokeMyFriendsUseCase(repository: pokeMyFriendsRepository)
        let viewModel = PokeMyFriendsViewModel(useCase: useCase, coordinator: coordinator)
        let pokeMyFriendsVC = PokeMyFriendsVC(viewModel: viewModel)
        
        return (pokeMyFriendsVC, viewModel)
    }
    
    public func makePokeMyFriendsList(relation: PokeFeatureInterface.PokeRelation) -> PokeFeatureInterface.PokeMyFriendsListPresentable {
        let useCase = DefaultPokeMyFriendsUseCase(repository: self.pokeMyFriendsRepository)
        let viewModel = PokeMyFriendsListViewModel(relation: relation, useCase: useCase)
        let pokeMyFriendsListVC = PokeMyFriendsListVC(viewModel: viewModel)
        
        return (pokeMyFriendsListVC, viewModel)
    }
    
    public func makePokeMessageTemplateBottomSheet(messageType: Domain.PokeMessageType) -> PokeFeatureInterface.PokeMessageTemplatesPresentable {
        let usecase = DefaultPokeMessageTemplateUsecase(repository: self.pokeOnboardingRepository)
        let viewModel = PokeMessageTemplateViewModel(messageType: messageType, usecase: usecase)
        let viewController = PokeMessageTemplateBottomSheet(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
    
    public func makePokeNotificationList(coordinator: Coordinator) -> PokeFeatureInterface.PokeNotificationPresentable {
        let usecase = DefaultPokeNotificationUsecase(repository: self.pokeNotificationListRepository)
        let viewModel = PokeNotificationViewModel(usecase: usecase,
                                                  coordinator: coordinator)
        let viewController = PokeNotificationViewController(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
    
    public func makePokeMakingFriendCompleted(friendName: String) -> any PokeFeatureInterface.PokeMakingFriendCompletedPresentable {
        let vc = PokeMakingFriendCompletedVC(friendName: friendName)
        
        return vc
    }
    
    public func makePokeAnonymousFriendUpgrade(user: Domain.PokeUserModel) -> any PokeFeatureInterface.PokeAnonymousFriendUpgradePresentable {
        let vc = PokeAnonymousFriendUpgradeVC(user: user)
        return vc
    }
}
