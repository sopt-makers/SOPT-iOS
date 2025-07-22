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
final class LegacySplashCoordinator: BaseCoordinator {
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
        var splash = factory.makeSplash(self)
        
        splash.vm.onNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel, as: .forceUpdate)
        }
        
        splash.vm.onNoticeSkipped = { [weak self] in
            self?.finishFlow?()
        }
        
        splash.vm.onOptionalNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel, as: .recommendUpdate)
        }
        router.setRootModule(splash.vc, animated: true)
    }
    
    private func presentNoticePopUp(model: AppNoticeModel, as type: NoticePopUpType) {
        let noticePopUpControllable = factory.makeNoticePopUpVC(
            noticeType: type,
            model: model
        )
        
        noticePopUpControllable.closeButtonTappedWithCheck.sink { [weak self] didCheck in
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }.store(in: cancelBag)
        
        router.present(noticePopUpControllable, animated: false, completion: nil)
    }
}

