//
//  MainNaviBar.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class MainNavigationBar: UIView {
    
    // MARK: - UI Components
    
    private let logoImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLogo.image.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleToFill
    }
    
    private let noticeButton = UIButton(type: .custom).then {
        $0.setImage(DSKitAsset.Assets.btnNotice.image, for: .normal)
    }
    
    private let myPageButton = UIButton(type: .custom).then {
        $0.setImage(DSKitAsset.Assets.btnMypage.image, for: .normal)
        $0.layer.cornerRadius = 22
        $0.backgroundColor = DSKitAsset.Colors.black60.color
    }
    
    private lazy var rightItemsStackView = UIStackView(arrangedSubviews: [noticeButton, myPageButton]).then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }

    // MARK: - initialization
    
    init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MainNavigationBar {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.addSubviews(logoImageView, rightItemsStackView)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(72)
        }
        
        rightItemsStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
