//
//  NotificationFilterCVC.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class NotificationFilterCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    var filterType: NotificationFilterType?
    
    override var isSelected: Bool {
        didSet {
            self.setSelectionStyle(isSelected: isSelected)
        }
    }
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        label.textColor = DSKitAsset.Colors.white.color
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

// MARK: - UI & Layouts

extension NotificationFilterCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.black60.color
        self.layer.borderWidth = 1
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
    }
    
    func setSelectionStyle(isSelected: Bool) {
        self.backgroundColor = isSelected ? DSKitAsset.Colors.gray700.color : DSKitAsset.Colors.gray800.color
        self.titleLabel.textColor = isSelected ? DSKitAsset.Colors.white.color : DSKitAsset.Colors.gray300.color
        self.layer.borderColor = isSelected ? DSKitAsset.Colors.gray100.color.cgColor : DSKitAsset.Colors.gray700.color.cgColor
    }
}

// MARK: - Methods

extension NotificationFilterCVC {
    func initCell(type: NotificationFilterType) {
        self.titleLabel.text = type.rawValue
        self.filterType = type
    }
}
