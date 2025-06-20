//
//  SplashBuilder.swift
//  SplashFeature
//
//  Created by Jae Hyun Lee on 5/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import SplashFeatureInterface

public final class SplashBuilder {
    @Injected public var repository: SplashRepositoryInterface
    
    public init() { }
}

extension SplashBuilder: SplashFeatureBuildable {
    public func makeSplash(_ coordinator: SplashCoordinatable) -> SplashPresentable {
        let useCase = DefaultSplashUseCase(repository: repository)
        let vm = SplashViewModel(useCase: useCase, coordinator: coordinator)
        let vc = SplashVC(viewModel: vm)
        return (vc, vm)
    }
    
    public func makeNoticePopUpVC(noticeType: Core.NoticePopUpType, content: String) -> NoticePopUpPresentable {
        let noticePopUpVC = NoticePopUpVC()
        noticePopUpVC.setData(type: noticeType, content: content)
        noticePopUpVC.modalPresentationStyle = .overFullScreen
        return noticePopUpVC
    }
}
