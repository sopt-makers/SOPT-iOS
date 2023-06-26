//
//  Coordinator.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/06/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

/// 모든 Coordinator가 따르는 Coordinator 프로토콜입니다.
public protocol Coordinator: AnyObject {
    /// start 메서드는 Coordinator가 담당하는 플로우를 시작하게 합니다. 대개의 경우 화면전환이 이뤄집니다.
    func start()
    
    /// DeepLink와 함께 화면전환을 하기 위한 star 메서드입니다.
    /// - Parameter option: DeepLinkOption을 추가하여 DeepLink 기능을 사용할 수 있습니다.
    func start(with option: DeepLinkOption?)
    
    /// CoordinatorStaringOption을 지정하여 원하는 화면전환 액션을 수행합니다.
    /// - Parameter style: modal 또는 Root 등의 옵션을 지정합니다.
    func start(by style: CoordinatorStartingOption)
}
