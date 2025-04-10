//
//  BaseCoordinator.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/06/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DeallocRegistered<T: TestCoordinatorFinishOutput> {
    public var wrappedValue: T {
        didSet { coordinator?.setDeallocallable(with: wrappedValue) }
    }
    
    public weak var coordinator: TestBaseCoordinator?

    public init(wrappedValue: T, coordinator: TestBaseCoordinator?) {
        self.wrappedValue = wrappedValue
        self.coordinator = coordinator
        coordinator?.setDeallocallable(with: wrappedValue)
    }
}

open class TestBaseCoordinator: TestCoordinator {
    public var stop: (() -> Void)?
    
    public func setDeallocallable(with object: any TestCoordinatorFinishOutput) {
        deallocallable?.onDeinit = nil // 기존 연결 해제
        object.onDeinit = { [weak self] in
            self?.stop?()
        }
        
        deallocallable = object
    }
    
    public weak var deallocallable: TestCoordinatorFinishOutput?
    
    
    // MARK: - Vars & Lets
    
    public var childCoordinators = [TestCoordinator]()
    
    // MARK: - Public methods
    
    /// 자식 코디네이터의 의존성을 추가하여 메모리에서 해제되지 않도록 합니다.
    public func addTestDependency(_ coordinator: TestCoordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    /// 자식 코디네이터의 의존성을 제거하여 메모리에서 해제되도록 합니다.
    public func removeTestDependency(_ coordinator: TestCoordinator?) {
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
    
    open func startCoordinator(with viewController: any TestCoordinatorFinishOutput) {

    }
    
    public init(childCoordinators: [TestCoordinator] = [TestCoordinator]()) {
        self.childCoordinators = childCoordinators
    }
}
