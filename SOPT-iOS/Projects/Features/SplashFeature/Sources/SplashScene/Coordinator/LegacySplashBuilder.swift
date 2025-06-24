//
//  LegacySplashBuilder.swift
//  SplashFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import SplashFeatureInterface

public
final class LegacySplashBuilder {
    public init() { }
}

extension LegacySplashBuilder: LegacySplashFeatureViewBuildable {
    public func makeSplash(_ coordinator: SplashCoordinatable) -> LegacySplashPresentable {
        let useCase = DefaultSplashUseCase()
        let vm = SplashViewModel(useCase: useCase, coordinator: coordinator)
        let vc = SplashVC(viewModel: vm)
        return (vc, vm)
    }
    
    public func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> LegacyNoticePopUpViewControllable {
        let noticePopUpVC = NoticePopUpVC()
        noticePopUpVC.setData(type: noticeType, content: content)
        noticePopUpVC.modalPresentationStyle = .overFullScreen
        return noticePopUpVC
    }
}
