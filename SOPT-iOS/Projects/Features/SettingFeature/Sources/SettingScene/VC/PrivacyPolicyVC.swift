//
//  PrivacyPolicyVC.swift
//  Presentation
//
//  Created by devxsby on 2022/12/29.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import DSKit

import Core

import SnapKit
import Then

import SettingFeatureInterface

public class PrivacyPolicyVC: UIViewController, PrivacyPolicyViewControllable {
        
    // MARK: - UI Components
    
    private lazy var naviBar = OPNavigationBar(
            self,
            type: .oneLeftButton,
            backgroundColor: DSKitAsset.Colors.black100.color
        )
        .addMiddleLabel(title: I18N.Setting.personalInfoPolicy)
    
    private let textView = UITextView().then {
        $0.text = I18N.ServiceUsagePolicy.privacyPolicy
        $0.setTypoStyle(DSKitFontFamily.Suit.regular.font(size: 14))
        $0.backgroundColor = DSKitAsset.Colors.black100.color
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.isEditable = false
        $0.showsVerticalScrollIndicator = false
        $0.setLineSpacing(lineSpacing: 5)
    }

    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDelegate()
    }
}

// MARK: - UI & Layout

extension PrivacyPolicyVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, textView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension PrivacyPolicyVC {
    
    private func setDelegate() {
        textView.delegate = self
    }
}

extension PrivacyPolicyVC: UITextViewDelegate {
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
