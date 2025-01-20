//
//  HomeBuilder.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import HomeFeatureInterface

public final class HomeBuilder {
    @Injected public var homeRepository: HomeRepositoryInterface
    
    public init() {}
}

extension HomeBuilder: HomeFeatureBuildable {
    
    public func makeHomeForMember() -> HomeForMemberPresentable {
        let useCase = DefaultHomeUseCase(repository: homeRepository)
        let viewModel = HomeForMemberViewModel(useCase: useCase)
        let homeForMemberVC = HomeForMemberVC(viewModel: viewModel)
        return (homeForMemberVC, viewModel)
    }
    
    public func makeHomeForVisitor() -> HomeForVisitorPresentable {
        let useCase = DefaultHomeUseCase(repository: homeRepository)
        let viewModel = HomeForVisitorViewModel(useCase: useCase)
        let homeForVisitorVC = HomeForVisitorVC(viewModel: viewModel)
        return (homeForVisitorVC, viewModel)
    }
    
    public func makeHomeCalendarDetail() -> HomeCalendarDetailPresentable {
        let useCase = DefaultHomeUseCase(repository: homeRepository)
        let viewModel = HomeCalendarDetailViewModel(useCase: useCase)
        let homeCalendarDetailVC = HomeCalendarDetailVC(viewModel: viewModel)
        return (homeCalendarDetailVC, viewModel)
    }
}
