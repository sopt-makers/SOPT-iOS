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
import TabBarFeatureInterface

final public class TabBarViewModel: TabBarViewModelType {
    
    private let cancelBag = CancelBag()
    private let userType: UserType
    
    public var onTabBarItemTapped: ((Int) -> Void)?
    public var showTabBarAlert: (() -> Void)?
    
    public struct Input {
        let isTabSelectedIndex: Driver<Int>
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
                    output.selectedIndex.send(1)
                }
            }.store(in: cancelBag)
        
        return output
    }
}
