//
//  TabBarViewModel.swift
//  TabBarFeatureDemo
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import BaseFeatureDependency

final public class TabBarViewModel: TabBarViewModelType {
    
    // MARK: - Properties
    
    private let cancelBag = CancelBag()
    private let userType: UserType
    private let coordinator: AnyCoordinatorObject
    private let homeUseCase: HomeUseCase
    @Published public private(set) var tabBarBadges: [TabBarItemType: String] = [:]
    
    // MARK: - Inputs
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let isTabSelectedIndex: Driver<Int>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let selectedIndex = PassthroughSubject<Int, Never>()
    }
    
    // MARK: - TabBarCoordinating
    
    public var onTabBarItemTapped: ((Int) -> Void)?
    public var showTabBarAlert: (() -> Void)?
    
    // MARK: - initialization
    
    public init(userType: UserType, coordinator: Coordinator, homeUseCase: HomeUseCase) {
        self.userType = userType
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
}

extension TabBarViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchAppServiceBadges()
            }.store(in: cancelBag)
        
        input.isTabSelectedIndex
            .withUnretained(self)
            .sink { owner, index in
                owner.onTabBarItemTapped?(index)
                owner.trackAmplitude(itemIndex: index)
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Methods

extension TabBarViewModel {
    private func trackAmplitude(itemIndex: Int) {
        if let item = TabBarItemType(rawValue: itemIndex) {
            AmplitudeInstance.shared.trackWithUserType(event: item.toAmplitudeEventType)
        }
    }
    
    private func fetchAppServiceBadges() {
        homeUseCase.getAppServices()
            .withUnretained(self)
            .sink { owner, appServices in
                owner.updateBadges(from: appServices)
            }
            .store(in: cancelBag)
    }
    
    private func updateBadges(from appServices: [HomeAppServicesModel]) {
        let badges = appServices
            .filter { $0.displayAlarmBadge }
            .compactMap { service -> (TabBarItemType, String)? in
                mapServiceNameToTabType(service.serviceName).map { ($0, service.alarmBadge) }
            }
        
        tabBarBadges = Dictionary(uniqueKeysWithValues: badges)
    }
    
    // 서비스명을 TabBarItemType으로 매핑
    private func mapServiceNameToTabType(_ serviceName: String) -> TabBarItemType? {
        switch serviceName {
        case "솝탬프":
            return .soptamp
        case "콕찌르기":
            return .poke
        default:
            return nil
        }
    }
}
