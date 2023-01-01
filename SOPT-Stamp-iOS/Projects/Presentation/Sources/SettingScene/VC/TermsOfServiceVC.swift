//
//  TermsOfServiceVC.swift
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

public class TermsOfServiceVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.Setting.serviceTerm)
        .setRightButton(.none)

    private let textView = UITextView().then {
        $0.text = I18N.serviceUsagePolicy.termsOfService
        $0.isEditable = false
        $0.showsVerticalScrollIndicator = false
        $0.setLineSpacing(lineSpacing: 5)
    }

    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
//        self.setDelegate()
    }
}

// MARK: - UI & Layout

extension TermsOfServiceVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.white.color
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

extension TermsOfServiceVC {
    
    private func setDelegate() {
        textView.delegate = self
    }
}

extension TermsOfServiceVC: UITextViewDelegate {
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
