//
//  BaseCoordinator.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/06/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

open class BaseCoordinator: Coordinator {
    
    // MARK: - Vars & Lets
    
    public var childCoordinators = [Coordinator]()
    
    // MARK: - Public methods
    
    /// 자식 코디네이터의 의존성을 추가하여 메모리에서 해제되지 않도록 합니다.
    public func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    /// 자식 코디네이터의 의존성을 제거하여 메모리에서 해제되도록 합니다.
    public func removeDependency(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    // MARK: - Coordinator
    
    open func start() {
        start(with: nil)
    }
    
    open func start(with option: DeepLinkOption?) {
        
    }
    
    open func start(by style: CoordinatorStartingOption) {
        
    }
    
    public init(childCoordinators: [Coordinator] = [Coordinator]()) {
        self.childCoordinators = childCoordinators
    }
}
