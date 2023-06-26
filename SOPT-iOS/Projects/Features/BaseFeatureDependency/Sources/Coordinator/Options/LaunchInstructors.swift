//
//  LaunchInstructors.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/06/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

/// AppCoordinator가 플로우의 시작을 결정할 수 있도록 하는 열거형입니다
/// 추후 자동로그인 구현 시에 사용할 수 있습니다.
enum LaunchInstructor {
    
    case main
    case auth
    case onboarding
    
    // MARK: - Public methods
    
    
    /// AppCoordinator의 분기를 결정할 때 사용합니다.
    /// - Parameters:
    ///   - isAutorized: 자동로그인이 활성화된 상태입니다.
    ///   - tutorialWasShown: Onboarding을 본 적이 있으면 true로 지정합니다.
    /// - Returns: 결과물로 App의 Flow 결정에 사용됩니다.
    static func configure(isAutorized: Bool = true, tutorialWasShown: Bool = true) -> LaunchInstructor {
        
        let isAutorized = isAutorized
        let tutorialWasShown = tutorialWasShown
        
//        if AuthUserDefaultsServices.shared().getToken() != nil {
//            isAutorized = true
//            tutorialWasShown = true
//        }
        
        switch (tutorialWasShown, isAutorized) {
            case (true, false), (false, false): return .auth
            case (false, true): return .onboarding
            case (true, true): return .main
        }
    }
}

