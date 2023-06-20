//
//  MyPageBuilder.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import AppMyPageFeatureInterface

public
final class MyPageBuilder {
    @Injected public var repository: AppMyPageRepositoryInterface
    
    public init() { }
}

extension MyPageBuilder: MyPageFeatureBuildable {
    public func makeAppMyPage(userType: UserType) -> MyPagePresentable {
        let useCase = DefaultAppMyPageUseCase(repository: repository)
        let vm = AppMyPageViewModel(useCase: useCase)
        let vc = AppMyPageVC(userType: userType, viewModel: vm)
        return (vc, vm)
    }
}
