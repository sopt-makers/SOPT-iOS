//
//  FindSocialVC.swift
//  AuthFeature
//
//  Created by 장석우 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit
import Core

import AuthFeatureInterface
import BaseFeatureDependency

import SnapKit
import Then

public class SearchSocialAccountVC: UIViewController, SearchSocialAccountViewControllable {
    
    //MARK: - Properties
    
    private let phoneVerifyView = PhoneVerifyView()
    
    private let viewModel: SearchSocialAccountViewModel
    private let phoneVerifyViewModel: PhoneVerifyViewModel
    
    private let cancelBag = CancelBag()
    
    // MARK: - Initialization
    
    public init(
        viewModel: SearchSocialAccountViewModel,
        phoneVerifyViewModel: PhoneVerifyViewModel
    ) {
        self.viewModel = viewModel
        self.phoneVerifyViewModel = phoneVerifyViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private lazy var navigationBar = OPNavigationBar(
        self,
        type: .oneLeftButton,
        backgroundColor: DSKitAsset.Colors.black100.color,
        ignoreLeftButtonAction: false
    )
   
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        bind()
    }

    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        self.phoneVerifyView.helpViewHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(
            navigationBar,
            phoneVerifyView
        )
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        phoneVerifyView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(54 )
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bind() {
        
        let pvInput = phoneVerifyView.viewModelInput
        let pvOutput = phoneVerifyViewModel.transform(from: pvInput, cancelBag: cancelBag)
        phoneVerifyView.bindOutput(pvOutput, cancelBag: cancelBag)
        
        let input = type(of: viewModel).Input.init(
            phone: pvOutput.phoneTextFieldText.asDriver(),
            verifySuccess: pvOutput.verifySuccess.asDriver()
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        
    }
    
}
