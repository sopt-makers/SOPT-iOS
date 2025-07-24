//
//  SplashBuilder.swift
//  SplashFeature
//
//  Created by Jae Hyun Lee on 5/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency
@_exported import SplashFeatureInterface

public final class SplashBuilder {
    @Injected public var repository: SplashRepositoryInterface
    
    public init() { }
}

extension SplashBuilder: SplashFeatureBuildable {
    public func makeSplash(_ coordinator: Coordinator) -> SplashPresentable {
        let useCase = DefaultSplashUseCase(repository: repository)
        let vm = SplashViewModel(useCase: useCase, coordinator: coordinator)
        let vc = SplashVC(viewModel: vm)
        return (vc, vm)
    }
    
    public func makeNoticePopUpVC(noticeType: NoticePopUpType, model: AppNoticeModel) -> NoticePopUpPresentable {
        let noticePopUpVC = NoticePopUpVC()
        noticePopUpVC.setData(type: noticeType, model: model)
        noticePopUpVC.modalPresentationStyle = .overFullScreen
        return noticePopUpVC
    }
}
