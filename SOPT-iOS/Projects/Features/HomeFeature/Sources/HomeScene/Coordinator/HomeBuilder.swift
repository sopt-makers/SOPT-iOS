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
    public init() {}
}

extension HomeBuilder: HomeFeatureBuildable {
    public func makeHomeForMember() -> HomeForMemberPresentable {
        let viewModel = HomeForMemberViewModel()
        let homeForMemberVC = HomeForMemberVC(viewModel: viewModel)
        return (homeForMemberVC, viewModel)
    }
    
    public func makeHomeForVisitor() -> HomeForVisitorPresentable {
        let viewModel = HomeForVisitorViewModel()
        let homeForVisitorVC = HomeForVisitorVC()
        return (homeForVisitorVC, viewModel)
    }
    
    public func makeHomeCalendarDetail() -> HomeCalendarDetailPresentable {
        let viewModel = HomeCalendarDetailViewModel()
        let homeCalendarDetailVC = HomeCalendarDetailVC(viewModel: viewModel)
        return (homeCalendarDetailVC, viewModel)
    }
}
