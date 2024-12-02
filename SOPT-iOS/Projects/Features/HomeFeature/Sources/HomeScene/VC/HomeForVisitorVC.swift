//
//  HomeForVisitorVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import BaseFeatureDependency

final class HomeForVisitorVC: UIViewController, HomeForVisitorViewControllable {
    
    // MARK: - UI Components
    
    private lazy var naviBar = HomeNavigationBar().hideNoticeButton()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension HomeForVisitorVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        view.addSubviews(naviBar)
        
        naviBar.snp.makeConstraints { make in
          make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension HomeForVisitorVC {
    
}
