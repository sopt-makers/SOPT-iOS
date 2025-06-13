//
//  SplashCoordinator.swift
//  SplashFeature
//
//  Created by Jae Hyun Lee on 5/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import SplashFeatureInterface
import Core
import Domain

public final class SplashCoordinator: DefaultCoordinator & SplashCoordinatable {
    
    // MARK: - SplashCoordinatable
    
    public var onNoticeSkipped: (() -> Void)?
    public var onNoticeExist: ((Domain.AppNoticeModel) -> Void)?
    public var finished: (() -> Void)?
    
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    
    private weak var navigationController: UINavigationController?
    private let factory: SplashFeatureBuildable
    private let cancelBag = CancelBag()
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: SplashFeatureBuildable
    ) {
        self.factory = factory
        self.navigationController = navigationController
        super.init()
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showSplash()
    }
    
    // MARK: - Navigation
    
    private func showSplash() {
        let splash = factory.makeSplash(self)
        
        onNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel)
        }
        
        onNoticeSkipped = { [weak self] in
            UIWindow.getRootNavigationController.viewControllers.removeAll()
            self?.finished?()
        }
        
        navigationController?.setViewControllers([splash.vc], animated: true)
    }
    
    private func presentNoticePopUp(model: AppNoticeModel) {
        guard let isForcedUpdate = model.isForced else { return }
        
        let popUpType: NoticePopUpType = isForcedUpdate ? .forceUpdate : .recommendUpdate
        
        let noticePopUpVC = factory.makeNoticePopUpVC(
            noticeType: popUpType,
            content: model.notice
        )
        
        noticePopUpVC.closeButtonTappedWithCheck.sink { [weak self] didCheck in
            if didCheck {
                UserDefaultKeyList.AppNotice.checkedAppVersion = model.recommendVersion
            }
            self?.navigationController?.dismiss(animated: true)
            self?.finished?()
        }.store(in: cancelBag)
        
        navigationController?.present(noticePopUpVC, animated: false)
    }
}
