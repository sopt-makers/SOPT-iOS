//
//  TestSplashCoordinator.swift
//  SplashFeature
//
//  Created by Jae Hyun Lee on 3/13/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import SplashFeatureInterface
import Core
import Domain


public final class TestSplashCoordinator: TestDefaultCoordinator {
    public var onDeinit: (() -> Void)?
    
    private let factory: SplashFeatureViewBuildable
    private let cancelBag = CancelBag()
    
    private let navigationController: UINavigationController?
    
    // 여기에서 상위 코디네이터를 주입받음
    
    public init(
        navigationController: UINavigationController,
        factory: SplashFeatureViewBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    deinit {
        
    }
    
    public override func start() {
        showSplash()
    }
    
    private func showSplash() {
        var splash = factory.makeSplash()
        setDeallocallable(with: splash.vc)
        
        splash.vm.onNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel)
        }
        splash.vm.onNoticeSkipped = { [weak self] in
            // 1. 여기에서 화면이 사라지는 순간
            self?.navigationController?.popViewController(animated: true)
        }
        
        navigationController?.pushViewController(splash.vc.viewController, animated: true)
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

            self?.navigationController?.dismiss(animated: true)

//            self?.finishFlow?()
        }.store(in: cancelBag)
        
        navigationController?.present(noticePopUpControllable.viewController, animated: false)
    }
}
