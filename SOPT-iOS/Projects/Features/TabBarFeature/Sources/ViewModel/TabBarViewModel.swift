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
import BaseFeatureDependency

final public class TabBarViewModel: TabBarViewModelType {
    
    // MARK: - Properties
    
    private let cancelBag = CancelBag()
    private let userType: UserType
    private let coordinator: AnyCoordinatorObject
    
    // MARK: - Inputs
    
    public struct Input {
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
    
    public init(userType: UserType, coordinator: Coordinator) {
        self.userType = userType
        self.coordinator = coordinator
    }
}

extension TabBarViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
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
}
