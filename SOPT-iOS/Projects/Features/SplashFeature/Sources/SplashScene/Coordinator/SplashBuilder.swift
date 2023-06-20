//
//  SplashBuilder.swift
//  SplashFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import SplashFeatureInterface

public
final class SplashBuilder {
    @Injected public var repository: AppNoticeRepositoryInterface
    
    public init() { }
}

extension SplashBuilder: SplashFeatureViewBuildable {
    public func makeSplash() -> SplashPresentable {
        let useCase = DefaultAppNoticeUseCase(repository: repository)
        let vm = SplashViewModel(useCase: useCase)
        let vc = SplashVC()
        vc.viewModel = vm
        return (vc, vm)
    }
    
    public func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> NoticePopUpViewControllable {
        let noticePopUpVC = NoticePopUpVC()
        noticePopUpVC.setData(type: noticeType, content: content)
        noticePopUpVC.modalPresentationStyle = .overFullScreen
        return noticePopUpVC
    }
}
