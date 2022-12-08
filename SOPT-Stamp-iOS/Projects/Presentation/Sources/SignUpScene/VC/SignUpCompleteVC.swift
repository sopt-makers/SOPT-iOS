//
//  SignUpCompleteVC.swift
//  Presentation
//
//  Created by sejin on 2022/12/05.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine

import Core
import DSKit

public class SignUpCompleteVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    
    // MARK: - UI Components
    
    private let characterImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.signUpCompleteImg.image.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let signUpCompleteLabel = UILabel().then {
        $0.text = I18N.SignUp.signUpComplete
        $0.textColor = DSKitAsset.Colors.gray900.color
        $0.font = UIFont.h1
    }
    
    private let welcomeLabel = UILabel().then {
        $0.text = I18N.SignUp.welcome
        $0.textColor = DSKitAsset.Colors.gray500.color
        $0.font = UIFont.subtitle2
    }
    
    private let startButton = CustomButton(title: I18N.SignUp.start)
        .setEnabled(true)
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

extension SignUpCompleteVC {
    
}

// MARK: - UI & Layout

extension SignUpCompleteVC {
    private func setUI() {
        self.view.backgroundColor = .white
    }
    
    private func setLayout() {
        self.view.addSubviews(characterImageView, signUpCompleteLabel, welcomeLabel, startButton)
        
        characterImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.75)
        }
        
        signUpCompleteLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(16)
            make.centerX.equalTo(characterImageView)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpCompleteLabel.snp.bottom).offset(4)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56)
        }
    }
}
