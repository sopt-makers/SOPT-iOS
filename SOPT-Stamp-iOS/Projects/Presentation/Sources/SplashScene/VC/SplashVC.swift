//
//  SplashVC.swift
//  Presentation
//
//  Created by devxsby on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import DSKit

import SnapKit
import Then

import Core

public class SplashVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    public var viewModel: SplashViewModel!
    
    private var cancelBag = CancelBag()
    
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
    
    private func presentNoticePopUp() {
        let popUp = factory.makeNoticePopUpVC()
        popUp.modalPresentationStyle = .overFullScreen
        popUp.setData(type: .recommendUpdate, content: "공지 내용")
        self.present(popUp, animated: true)
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
        let input = SplashViewModel.Input(viewDidLoad: Driver.just(()))
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
}
