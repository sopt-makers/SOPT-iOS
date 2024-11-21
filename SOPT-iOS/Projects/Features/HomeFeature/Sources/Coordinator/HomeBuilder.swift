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
        let homeForMemberVC = HomeForMemberVC()
        let viewModel = HomeForMemberViewModel()
        return (homeForMemberVC, viewModel)
    }
    
    public func makeHomeForVisitor() -> HomeForVisitorPresentable {
        let homeForVisitorVC = HomeForVisitorVC()
        let viewModel = HomeForVisitorViewModel()
        return (homeForVisitorVC, viewModel)
    }
}
