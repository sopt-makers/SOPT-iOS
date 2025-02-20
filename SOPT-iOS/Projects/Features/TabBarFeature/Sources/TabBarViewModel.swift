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
    @Published var selectedIndex: Int = 0
    
    public var onTabBarItemTapped: ((Int) -> Void)?
    
    public struct Input {}
    public struct Output {}
    
    public init() {
        
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        return output
    }
    
    private func bind() {
        $selectedIndex
            .withUnretained(self)
            .sink { owner, index in
                owner.onTabBarItemTapped?(index)
            }.store(in: cancelBag)
    }
}
