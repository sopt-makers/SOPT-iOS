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

public class SplashVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    public var viewModel: SplashViewModel!
    
    private var cancelBag = CancelBag()
    
    private var requestAppNotice = CurrentValueSubject<Void, Never>(())
    private var recommendUpdateVersionChecked = PassthroughSubject<String?, Never>()
    
    // MARK: - UI Components
    
    private let logoImage = UIImageView().then {
        $0.image = DSKitAsset.Assets.logo.image.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setNavigationBar()
        self.bindViewModels()
    }
}

// MARK: - UI & Layout

extension SplashVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.white.color
    }
    
    private func setLayout() {
        self.view.addSubviews(logoImage)
        
        logoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
    }
}

// MARK: - Methods

extension SplashVC {
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func presentNoticePopUp(model: AppNoticeModel) {
        guard let isForcedUpdate = model.isForced else { return }
        let popUpType: NoticePopUpType = isForcedUpdate ? .forceUpdate : .recommendUpdate
        
        let noticePopUpVC = factory.makeNoticePopUpVC(noticeType: popUpType, content: model.notice)

        noticePopUpVC.closeButtonTappedWithCheck.sink { [weak self] didCheck in
            self?.recommendUpdateVersionChecked.send(didCheck ? model.recommendVersion : nil)
            noticePopUpVC.dismiss(animated: false)
            self?.setDelay()
        }.store(in: cancelBag)
        
        self.present(noticePopUpVC, animated: false)
    }
    
    private func setDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let needAuth = UserDefaultKeyList.Auth.userId == nil
            if !needAuth {
                let navigation = UINavigationController(rootViewController: self.factory.makeMissionListVC(sceneType: .default))
                ViewControllerUtils.setRootViewController(window: self.view.window!, viewController: navigation, withAnimation: true)
            } else {
                let nextVC = self.factory.makeOnboardingVC()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    private func bindViewModels() {
        let input = SplashViewModel.Input(requestAppNotice: self.requestAppNotice,
                                          recommendUpdateVersionChecked: self.recommendUpdateVersionChecked)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
                
        output.appNoticeModel
        .sink { event in
            switch event {
            case .failure(let error):
                print(error.localizedDescription)
                self.presentNetworkAlertVC()
            case .finished:
                print("SplashVC: \(event)")
            }
        } receiveValue: { [weak self] appNoticeModel in
            guard let self = self else { return }
            guard let appNoticeModel = appNoticeModel else {
                self.setDelay()
                return
            }
            self.presentNoticePopUp(model: appNoticeModel)
        }.store(in: self.cancelBag)
    }
    
    private func presentNetworkAlertVC() {
        let networkAlertVC = self.factory.makeAlertVC(type: .titleDescription,
                                                      title: I18N.Default.networkError,
                                                      description: I18N.Default.networkErrorDescription,
                                                      customButtonTitle: I18N.Default.ok)
        networkAlertVC.customAction = { [weak self] in
            self?.requestAppNotice.send()
        }
        self.present(networkAlertVC, animated: false)
    }
}
