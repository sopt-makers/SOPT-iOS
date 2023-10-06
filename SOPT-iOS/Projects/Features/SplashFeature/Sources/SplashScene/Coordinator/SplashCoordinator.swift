//
//  SplashCoordinator.swift
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
final class SplashCoordinator: DefaultCoordinator {
    
    public var finishFlow: (() -> Void)?
    
    private let factory: SplashFeatureViewBuildable
    private let router: Router
    private let cancelBag = CancelBag()
    
    public init(router: Router, factory: SplashFeatureViewBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showSplash()
    }
    
    private func showSplash() {
        var splash = factory.makeSplash()
        splash.vm.onNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel)
        }
        splash.vm.onNoticeSkipped = { [weak self] in
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

