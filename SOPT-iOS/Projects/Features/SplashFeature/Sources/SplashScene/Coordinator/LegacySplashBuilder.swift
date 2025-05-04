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
    @Injected public var repository: SplashRepositoryInterface
    
    public init() { }
}

extension LegacySplashBuilder: LegacySplashFeatureViewBuildable {
    public func makeSplash() -> LegacySplashPresentable {
        let useCase = DefaultSplashUseCase(repository: repository)
        let vm = SplashViewModel(useCase: useCase)
        let vc = SplashVC()
        vc.viewModel = vm
        return (vc, vm)
    }
    
    public func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> LegacyNoticePopUpViewControllable {
        let noticePopUpVC = NoticePopUpVC()
        noticePopUpVC.setData(type: noticeType, content: content)
        noticePopUpVC.modalPresentationStyle = .overFullScreen
        return noticePopUpVC
    }
}
