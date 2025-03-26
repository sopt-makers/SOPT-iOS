//
//  SoptlogToolTipVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 3/26/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import SnapKit

final class SoptlogToolTipVC: UIViewController {

    // MARK: - UI Components
    
    private let infoImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icInfo.image
    }
    
    private let dismissButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icCloseWhite.image, for: .normal)
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.tooltipArrow.image
    }
    
    private let toolTipView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray600.color
        $0.layer.cornerRadius = 12
    }
    
    private let toolTipTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let infoTitleLabel = UILabel().then {
        $0.text = I18N.Soptlog.toolTipTitle
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private let infoContentsLabel = UILabel().then {
        $0.text = I18N.Soptlog.toolTip
        $0.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.numberOfLines = 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

extension SoptlogToolTipVC {
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.black100.color.withAlphaComponent(0.6)
    }
    
    private func setLayout() {
        setStackView()
        toolTipView.addSubviews(toolTipTitleStackView, infoContentsLabel)
        view.addSubviews(toolTipView, arrowImageView)
        
        // TODO: - 매개변수로 i 이미지 위치 받아서 toolTipView 위치 정해야 함.
        toolTipView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(294)
            make.leading.equalToSuperview().inset(68)
            make.trailing.equalToSuperview().inset(44)
            make.height.equalTo(100)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        
        toolTipTitleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(20)
        }
        
        infoContentsLabel.snp.makeConstraints { make in
            make.top.equalTo(toolTipTitleStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(16)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.leading.equalTo(toolTipView.snp.leading).inset(20)
            make.bottom.equalTo(toolTipView.snp.top)
            make.size.equalTo(12)
        }
    }
    
    private func setStackView() {
        toolTipTitleStackView.addArrangedSubviews(infoImageView, infoTitleLabel, dismissButton)
    }
}
