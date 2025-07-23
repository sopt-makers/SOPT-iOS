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

public final class SplashCoordinator: BaseCoordinator & SplashCoordinatorFinishOutput {
    
    // MARK: - Properties
    
    private weak var navigationController: UINavigationController?
    private let factory: SplashFeatureBuildable
    private let cancelBag = CancelBag()
    
    public var finished: (() -> Void)?
    
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
        var splash = factory.makeSplash(self)
        
        splash.vm.onNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel, as: .forceUpdate)
        }
        
        splash.vm.onNoticeSkipped = { [weak self] in
            self?.finished?()
        }
        
        splash.vm.onOptionalNoticeExist = { [weak self] appNoticeModel in
            self?.presentNoticePopUp(model: appNoticeModel, as: .recommendUpdate)
        }
        
        navigationController?.setViewControllers([splash.vc], animated: true)
    }
    
    private func presentNoticePopUp(model: AppNoticeModel, as type: NoticePopUpType) {
        let noticePopUpVC = factory.makeNoticePopUpVC(noticeType: type, model: model)
        
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
