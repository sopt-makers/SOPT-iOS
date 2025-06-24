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
    public var onOptionalNoticeExist: ((Domain.AppNoticeModel) -> Void)?
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
            self?.presentNoticePopUp(model: appNoticeModel, as: .forceUpdate)
        }
        
        onNoticeSkipped = { [weak self] in
            self?.finished?()
        }
        
        onOptionalNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel, as: .recommendUpdate)
        }
        
        navigationController?.setViewControllers([splash.vc], animated: true)
    }
    
    private func presentNoticePopUp(model: AppNoticeModel, as type: NoticePopUpType) {
        let noticePopUpVC = factory.makeNoticePopUpVC(
            noticeType: type,
            content: model.notice
        )
        
        noticePopUpVC.closeButtonTappedWithCheck.sink { [weak self] didCheck in
            self?.navigationController?.dismiss(animated: true)
            self?.finished?()
        }.store(in: cancelBag)
        
        navigationController?.present(noticePopUpVC, animated: false)
    }
    
    public func showNetworkAlert() {
        AlertUtils.presentAlertVC(
            type: .titleDescription,
            theme: .main,
            title: I18N.Default.networkError,
            description: I18N.Default.networkErrorDescription,
            customButtonTitle: I18N.Default.ok
        )
    }
}
