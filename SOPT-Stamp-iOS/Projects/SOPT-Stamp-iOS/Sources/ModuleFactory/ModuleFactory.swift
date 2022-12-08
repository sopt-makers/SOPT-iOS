//
//  ModuleFactory.swift
//  SOPT-Stamp-iOS
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Presentation
import Network
import Domain
import Data

public class ModuleFactory {
    static let shared = ModuleFactory()
    private init() { }
    
    lazy var authService = DefaultAuthService()
}

extension ModuleFactory: ModuleFactoryInterface {
    public func makeSplashVC() -> Presentation.SplashVC {
        let splashVC = SplashVC()
        splashVC.factory = self
        return splashVC
    }
    
    public func makeOnboardingVC() -> Presentation.OnboardingVC {
        let onboardingVC = OnboardingVC()
        onboardingVC.factory = self
        return onboardingVC
    }
    
    public func makeSignInVC() -> Presentation.SignInVC {
        let repository = SignInRepository(service: authService)
        let useCase = DefaultSignInUseCase(repository: repository)
        let viewModel = SignInViewModel(useCase: useCase)
        let signinVC = SignInVC()
        signinVC.factory = self
        signinVC.viewModel = viewModel
        return signinVC
    }
    
}
