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
    
    private let coordinator: AnyCoordinatorObject
    private let cancelBag = CancelBag()
    private let homeUseCase: HomeUseCase

    private let userType: UserType
    private let tabTypes: [TabBarItemType]
    @Published public private(set) var tabBarBadges: [TabBarItemType: String] = [:]
    @Published private(set) var isFABTapped: Bool = false
    
    // MARK: - Inputs
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let isTabSelectedIndex: Driver<Int>
        let isFABTapped: Driver<Void>
        let isMenuCellTapped: Driver<String>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let selectedIndex = PassthroughSubject<Int, Never>()
    }
    
    // MARK: - TabBarCoordinating
    
    public var onTabBarItemTapped: ((TabBarItemType) -> Void)?
    public var onFABMenuTapped: ((String) -> Void)?
    public var showTabBarAlert: (() -> Void)?
    
    // MARK: - initialization
    
    public init(userType: UserType, tabTypes: [TabBarItemType], coordinator: Coordinator, homeUseCase: HomeUseCase) {
        self.userType = userType
        self.tabTypes = tabTypes
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
                guard let tabBar = TabBarItemType.from(index: index, in: owner.tabTypes) else { return }
                
                // Visitor가 마이페이지 탭을 선택하면 로그인 Alert 표시
                if owner.userType == .visitor && tabBar == .mypage {
                    output.selectedIndex.send(0) // 홈 탭 인덱스
                    owner.showTabBarAlert?()

                    return
                }
                
                owner.onTabBarItemTapped?(tabBar)
                owner.trackAmplitude(itemType: tabBar)
            }.store(in: cancelBag)
        
        input.isFABTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.isFABTapped.toggle()
                if owner.isFABTapped {
                    AmplitudeInstance.shared.trackWithUserType(event: .clickPlusButton)
                }
            }.store(in: cancelBag)
        
        input.isMenuCellTapped
            .withUnretained(self)
            .sink { owner, url in
                owner.onFABMenuTapped?(url)
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Methods

extension TabBarViewModel {
    private func trackAmplitude(itemType: TabBarItemType) {
        AmplitudeInstance.shared.trackWithUserType(event: itemType.toAmplitudeEventType)
    }
    
    private func fetchAppServiceBadges() {
        Task { [weak self] in
            guard let self, let appServices = try? await self.homeUseCase.getTabAppServicesAsync() else { return }
            self.updateBadges(from: appServices)
        }
    }
    
    private func updateBadges(from appServices: [HomeAppServicesModel]) {
        let badges = appServices
            .filter { $0.displayAlarmBadge }
            .compactMap { service -> (TabBarItemType, String)? in
                TabBarItemType.from(tabAppServiceName: service.serviceName).map { ($0, service.alarmBadge) }
            }

        tabBarBadges = Dictionary(uniqueKeysWithValues: badges)
    }
}
