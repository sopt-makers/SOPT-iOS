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

public class SplashVC: UIViewController, SplashViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: SplashViewModel!
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let logoImage = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLogoBig.image.withRenderingMode(.alwaysOriginal)
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
        static let topInset = 151.adjustedH + 137.adjustedH
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
        let input = SplashViewModel.Input()
        let _ = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
}
