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
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        label.textColor = DSKitAsset.Colors.white100.color
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
}

// MARK: - UI & Layouts

extension NotificationFilterCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.black60.color
        self.layer.cornerRadius = 4
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    func setSelectionStyle(isSelected: Bool) {
        self.backgroundColor = isSelected ? DSKitAsset.Colors.purple100.color : DSKitAsset.Colors.black60.color
    }
}

// MARK: - Methods

extension NotificationFilterCVC {
    func initCell(type: NotificationFilterType) {
        self.titleLabel.text = type.rawValue
        self.filterType = type
    }
}
