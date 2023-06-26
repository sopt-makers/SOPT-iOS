//
//  MainBuilder.swift
//  MainFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import MainFeatureInterface

public
final class MainBuilder {
    @Injected public var repository: MainRepositoryInterface
    
    public init() { }
}

extension MainBuilder: MainFeatureViewBuildable {
    public func makeMain(userType: UserType) -> MainPresentable {
        let useCase = DefaultMainUseCase(repository: repository)
        let vm = MainViewModel(useCase: useCase, userType: userType)
        let vc = MainVC()
        vc.viewModel = vm
        return (vc, vm)
    }
}
