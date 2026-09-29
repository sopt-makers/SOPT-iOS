//
//  BaseCoordinator.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/06/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

open class BaseCoordinator: Coordinator {
    open func start() { start(with: nil) }
    open func start(with option: DeepLinkOption?) { }
    open func start(by style: CoordinatorStartingOption) { }
    
    public init() {}
}
