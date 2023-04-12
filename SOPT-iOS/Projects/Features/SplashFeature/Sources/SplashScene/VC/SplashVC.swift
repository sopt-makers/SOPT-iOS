//
//  SplashVC.swift
//  Presentation
//
//  Created by devxsby on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit
import Domain

import SnapKit
import Then

import BaseFeatureDependency
import SplashFeatureInterface
import AuthFeatureInterface
import MainFeatureInterface

public class SplashVC: UIViewController, SplashViewControllable {
    
    // MARK: - Properties
    
    public var factory: (SplashFeatureViewBuildable & AuthFeatureViewBuildable & MainFeatureViewBuildable & AlertViewBuildable)!
    public var viewModel: SplashViewModel!
    
    private var cancelBag = CancelBag()
    
    private var requestAppNotice = CurrentValueSubject<Void, Never>(())
    private var recommendUpdateVersionChecked = PassthroughSubject<String?, Never>()
    
    // MARK: - UI Components
    
    private let logoImage = UIImageView().then {
        $0.image = DSKitAsset.Assets.splashLogo.image.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setNavigationBar()
        self.setDelay()
    }
}

// MARK: - UI & Layout

extension SplashVC {
    
    private enum Metric {
        static let logoWidth = 184.adjusted
        static let topInset = 151.adjustedH + 137.adjustedH + 5.adjustedH
    }
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.soptampBlack.color
    }
    
    private func setLayout() {
        self.view.addSubviews(logoImage)
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.topInset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.logoWidth)
            make.height.equalTo(Metric.logoWidth).multipliedBy(114 / 184)
        }
    }
}

// MARK: - Methods

extension SplashVC {
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.bindViewModels()
        }
    }
    
    private func bindViewModels() {
        let input = SplashViewModel.Input(requestAppNotice: self.requestAppNotice,
                                          recommendUpdateVersionChecked: self.recommendUpdateVersionChecked)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.appNoticeModel
            .sink { event in
                print("SplashVC: \(event)")
            } receiveValue: { [weak self] appNoticeModel in
                guard let self = self else { return }
                guard let appNoticeModel = appNoticeModel else {
                    self.checkDidSignIn()
                    return
                }
                guard appNoticeModel.withError == false else {
                    self.presentNetworkAlertVC()
                    return
                }
                self.presentNoticePopUp(model: appNoticeModel)
            }.store(in: self.cancelBag)
    }
    
    private func presentNoticePopUp(model: AppNoticeModel) {
        guard let isForcedUpdate = model.isForced else { return }
        let popUpType: NoticePopUpType = isForcedUpdate ? .forceUpdate : .recommendUpdate
        
        let noticePopUpScene = factory.makeNoticePopUpVC(noticeType: popUpType, content: model.notice)
        let noticePopUpVC = noticePopUpScene.viewController
        
        noticePopUpScene.closeButtonTappedWithCheck.sink { [weak self] didCheck in
            self?.recommendUpdateVersionChecked.send(didCheck ? model.recommendVersion : nil)
            noticePopUpVC.dismiss(animated: false)
            self?.checkDidSignIn()
        }.store(in: cancelBag)
        
        self.present(noticePopUpVC, animated: false)
    }
    
    private func checkDidSignIn() {
        let needAuth = UserDefaultKeyList.Auth.appAccessToken == nil
        needAuth ? presentSignInVC() : setRootViewToMain()
    }
    
    private func setRootViewToMain() {
        let userType = UserDefaultKeyList.Auth.getUserType()
        let navigation = UINavigationController(rootViewController: factory.makeMainVC(userType: userType).viewController)
        ViewControllerUtils.setRootViewController(window: self.view.window!, viewController: navigation, withAnimation: true)
    }
    
    private func presentSignInVC() {
        let nextVC = factory.makeSignInVC().viewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true)
    }
    
    private func presentNetworkAlertVC() {
        let networkAlertVC = factory.makeAlertVC(
            type: .titleDescription,
            title: I18N.Default.networkError,
            description: I18N.Default.networkErrorDescription,
            customButtonTitle: I18N.Default.ok,
            customAction:{ [weak self] in
                self?.requestAppNotice.send()
            }).viewController
        
        self.present(networkAlertVC, animated: false)
    }
}
