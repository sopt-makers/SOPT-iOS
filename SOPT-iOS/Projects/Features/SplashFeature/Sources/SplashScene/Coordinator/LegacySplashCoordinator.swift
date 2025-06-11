//
//  LegacySplashCoordinator.swift
//  SplashFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import SplashFeatureInterface
import Core
import Domain

public
final class LegacySplashCoordinator: DefaultCoordinator & SplashCoordinatable {
    public var checkSignInFlow: (() -> Void)?
    public var onNoticeSkipped: (() -> Void)?
    public var onNoticeExist: ((Domain.AppNoticeModel) -> Void)?
    
    
    public var finishFlow: (() -> Void)?
    
    private let factory: LegacySplashFeatureViewBuildable
    private let router: LegacyRouter
    private let cancelBag = CancelBag()
    
    public init(router: LegacyRouter, factory: LegacySplashFeatureViewBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showSplash()
    }
    
    private func showSplash() {
        let splash = factory.makeSplash(self)
        onNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel)
        }
        onNoticeSkipped = { [weak self] in
            self?.finishFlow?()
        }
        router.setRootModule(splash.vc, animated: true)
    }
    
    private func presentNoticePopUp(model: AppNoticeModel) {
        guard let isForcedUpdate = model.isForced else { return }
        
        let popUpType: NoticePopUpType = isForcedUpdate ? .forceUpdate : .recommendUpdate
        
        let noticePopUpControllable = factory.makeNoticePopUpVC(
            noticeType: popUpType,
            content: model.notice
        )
        
        noticePopUpControllable.closeButtonTappedWithCheck.sink { [weak self] didCheck in
            if didCheck {
                UserDefaultKeyList.AppNotice.checkedAppVersion = model.recommendVersion
            }
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }.store(in: cancelBag)
        
        router.present(noticePopUpControllable, animated: false, completion: nil)
    }
}

