//
//  SoptlogAlarmCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogAlarmCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private var serviceImageView = UIImageView()

    private let titleLabel = UILabel().then {
        $0.text = "차은우님, 잊지 말아야 할 말을 듣게 될 거예요"
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 18)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "오늘의 솝마디 >"
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SoptlogAlarmCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        contentView.addSubviews(serviceImageView, labelStackView)
        
        serviceImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(serviceImageView.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setStackView() {
        labelStackView.addArrangedSubviews(titleLabel, subTitleLabel)
    }
    
    func configureCell(title: String, image: UIImage, subTitle: String) {
        self.titleLabel.text = title
        self.serviceImageView.image = image
        self.subTitleLabel.text = subTitle
    }
}
