//
//  MyPageCVC.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

final class MyPageCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
    }
    private let arrowImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnArrowRight.image
    }
    
    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
}

// MARK: - UI & Layout

extension MyPageCVC {
    private func setUI() {
        self.backgroundColor = .clear
    }

    private func setLayout() {
        contentView.addSubviews(titleLabel, arrowImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.directionalVerticalEdges.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(16)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
}

// MARK: - Methods

extension MyPageCVC {
    func configureCell(model: MyPageItem) {
        self.titleLabel.text = model.title
        self.arrowImageView.isHidden = !model.hasArrow
    }
}
