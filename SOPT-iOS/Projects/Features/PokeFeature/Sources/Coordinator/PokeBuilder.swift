//
//  PokeBuilder.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import PokeFeatureInterface

public final class PokeBuilder {
    @Injected public var pokeMainRepository: PokeMainRepositoryInterface
    @Injected public var pokeMyFriendsRepository: PokeMyFriendsRepositoryInterface
    @Injected public var pokeOnboardingRepository: PokeOnboardingRepositoryInterface
    
    public init() {}
}

extension PokeBuilder: PokeFeatureBuildable {
    public func makePokeMain() -> PokeFeatureInterface.PokeMainPresentable {
        let useCase = DefaultPokeMainUseCase(repository: pokeMainRepository)
        let viewModel = PokeMainViewModel(useCase: useCase)
        let pokeMainVC = PokeMainVC(viewModel: viewModel)
        return (pokeMainVC, viewModel)
    }
    
    public func makePokeMyFriends() -> PokeFeatureInterface.PokeMyFriendsPresentable {
        let useCase = DefaultPokeMyFriendsUseCase(repository: pokeMyFriendsRepository)
        let viewModel = PokeMyFriendsViewModel(useCase: useCase)
        let pokeMyFriendsVC = PokeMyFriendsVC(viewModel: viewModel)
        
        return (pokeMyFriendsVC, viewModel)
    }
    
    public func makePokeOnboarding() -> PokeFeatureInterface.PokeOnboardingPresentable {
        let usecase = DefaultPokeOnboardingUsecase(repository: self.pokeOnboardingRepository)
        let viewModel = PokeOnboardingViewModel(usecase: usecase)
        let viewController = PokeOnboardingViewController(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
    
    public func makePokeMessageTemplateBottomSheet() -> PokeMessageTemplatesPresentable {
        let usecase = DefaultPokeMessageTemplateUsecase(repository: self.pokeOnboardingRepository)
        let viewModel = PokeMessageTemplateViewModel(usecase: usecase)
        let viewController = PokeMessageTemplateBottomSheet(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
}
