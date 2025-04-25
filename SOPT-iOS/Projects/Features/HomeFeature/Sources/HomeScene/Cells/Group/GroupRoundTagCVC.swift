//
//  HomeRoundTagView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class GroupRoundTagCVC: UICollectionViewCell {

    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        $0.textColor = DSKitAsset.Colors.gray100.color
        $0.textAlignment = .center
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
}

// MARK: - UI & Layout

extension GroupRoundTagCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray700.color
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(5)
        }
    }
    
    private func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}

// MARK: - Methods

extension GroupRoundTagCVC {
    func configureCell(text: String?) {
        guard let text else { return }
        self.titleLabel.text = text
    }
}
