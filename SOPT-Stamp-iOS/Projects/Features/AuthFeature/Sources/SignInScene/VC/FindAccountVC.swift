//
//  FindAccountVC.swift
//  Presentation
//
//  Created by devxsby on 2023/01/01.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import DSKit

import Core

import AuthFeatureInterface

public class FindAccountVC: UIViewController, AuthFeatureViewControllable {
    
    // MARK: - UI Components

    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.SignIn.findAccount)
    
    private let descriptionLabel = UILabel().then {
        $0.text = I18N.SignIn.findDescription
        $0.textColor = DSKitAsset.Colors.gray700.color
        $0.textAlignment = .left
        $0.numberOfLines = 3
        $0.font = UIFont.subtitle3
        $0.setLineSpacing(lineSpacing: 10)
    }
    
    private lazy var findEmailButton = UIButton(type: .system).then {
        $0.setTitle(I18N.SignIn.findEmail, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(findEmailButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var findPasswordButton = UIButton(type: .system).then {
        $0.setTitle(I18N.SignIn.findPassword, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(findPasswordButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
    
    // MARK: - @objc Function
    
    @objc
    private func findEmailButtonDidTap() {
        self.openExternalLink(urlStr: ExternalURL.GoogleForms.findEmail)
    }
    
    @objc
    private func findPasswordButtonDidTap() {
        self.openExternalLink(urlStr: ExternalURL.GoogleForms.findPassword)
    }
}

// MARK: - UI & Layout

extension FindAccountVC {
    
    private func setUI() {
        self.view.backgroundColor = .white
        [findEmailButton, findPasswordButton].forEach {
            $0.layer.cornerRadius = 9
            $0.backgroundColor = DSKitAsset.Colors.purple200.color
            $0.setTitleColor(DSKitAsset.Colors.purple300.color, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            $0.titleLabel!.setTypoStyle(.h3)
        }
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, descriptionLabel, findEmailButton, findPasswordButton)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        
        [findEmailButton, findPasswordButton].forEach {
            let arrowImageView = UIImageView().then {
                $0.contentMode = .scaleAspectFit
                $0.image = DSKitAsset.Assets.icLeftArrow.image.withRenderingMode(.alwaysTemplate)
                $0.tintColor = DSKitAsset.Colors.purple300.color
            }
            
            $0.addSubview(arrowImageView)
            arrowImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(4)
                make.size.equalTo(32)
            }
        }
        
        findEmailButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(findEmailButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
    }
}

// MARK: - Methods

extension FindAccountVC {
    
    public func openExternalLink(urlStr: String, _ handler: (() -> Void)? = nil) {
        guard let url = URL(string: urlStr) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { _ in
                handler?()
            }
        } else {
            UIApplication.shared.openURL(url)
            handler?()
        }
    }
}
