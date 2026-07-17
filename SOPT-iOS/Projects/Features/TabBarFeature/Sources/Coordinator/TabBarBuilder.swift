//
//  TabBarBuilder.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
@_exported import TabBarFeatureInterface

public final class TabBarBuilder {
    @Injected public var homeRepository: HomeRepositoryInterface
    
    public init() {}
}

extension TabBarBuilder: TabBarBuildable {
    public func makeTabBar(with views: [UIViewController], tabTypes: [TabBarItemType], userType: UserType, coordinator: Coordinator) -> TabBarPresentable {
        let homeUseCase = DefaultHomeUseCase(repository: homeRepository)
        let viewModel = TabBarViewModel(userType: userType, tabTypes: tabTypes, coordinator: coordinator, homeUseCase: homeUseCase)
        let tabBarVC = TabBarController(viewModel: viewModel, tabList: views, tabTypes: tabTypes, userType: userType)
        return (tabBarVC, viewModel)
    }
}

extension TabBarBuilder {
    /// 후보 탭 중 실제로 탭바에 노출할 탭 구성을 결정합니다.
    /// 콕찌르기/솝탬프는 tab-app-service 응답에 존재할 때만 포함되며, 나머지 후보는 항상 포함됩니다.
    /// 네트워크 실패 시에는 기존 UX(콕찌르기 탭만 노출)로 폴백합니다.
    public func resolveActiveTabTypes(
        candidates: [(type: TabBarItemType, viewController: UIViewController)],
        userType: UserType
    ) async -> [TabBarItemType] {
        let conditionalTypes: Set<TabBarItemType> = [.poke, .soptamp]

        guard candidates.contains(where: { conditionalTypes.contains($0.type) }) else {
            return candidates.map(\.type)
        }

        let homeUseCase = DefaultHomeUseCase(repository: homeRepository)
        let presentTypes: Set<TabBarItemType>
        if let services = try? await homeUseCase.getTabAppServicesAsync() {
            presentTypes = Set(services.compactMap { TabBarItemType.from(tabAppServiceName: $0.serviceName) })
        } else {
            presentTypes = [.poke]
        }

        return candidates
            .filter { !conditionalTypes.contains($0.type) || presentTypes.contains($0.type) }
            .map(\.type)
    }
}
