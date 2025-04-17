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

final public class TabBarViewModel: TabBarViewModelType {
    
    private let cancelBag = CancelBag()
    private let userType: UserType
    @Published private(set) var isFABTapped: Bool = false
    
    public var onTabBarItemTapped: ((Int) -> Void)?
    public var onFABMenuTapped: ((String) -> Void)?
    public var showTabBarAlert: (() -> Void)?
    
    public struct Input {
        let isTabSelectedIndex: Driver<Int>
        let isFABTapped: Driver<Void>
        let isMenuCellTapped: Driver<String>
    }
    
    public struct Output {
        let selectedIndex = PassthroughSubject<Int, Never>()
    }
    
    public init(userType: UserType) {
        self.userType = userType
    }
}

extension TabBarViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.isTabSelectedIndex
            .withUnretained(self)
            .sink { owner, index in
                if index == 1, owner.userType == .visitor {
                    owner.showTabBarAlert?()
                    output.selectedIndex.send(0)
                } else {
                    owner.onTabBarItemTapped?(index)
                    owner.trackAmplitude(itemIndex: index)
                }
            }.store(in: cancelBag)
        
        input.isFABTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.isFABTapped.toggle()
            }.store(in: cancelBag)
        
        input.isMenuCellTapped
            .withUnretained(self)
            .sink { owner, url in
                owner.onFABMenuTapped?(url)
            }.store(in: cancelBag)
        
        return output
    }
}

extension TabBarViewModel {
    private func trackAmplitude(itemIndex: Int) {
        if let item = TabBarItemType(rawValue: itemIndex) {
            AmplitudeInstance.shared.trackWithUserType(event: item.toAmplitudeEventType)
        }
    }
}
