//
//  NotificationFilterCVC.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class NotificationFilterCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    var filterType: NotificationFilterType?
    
    override var isSelected: Bool {
        didSet {
            self.setSelectionStyle(isSelected: isSelected)
        }
    }
    
    // MARK: - UI Components
    
    private let chip = MDSChip(size: .small, type: .solid, prefixIcon: nil, suffixIcon: nil)
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
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
        self.addSubviews(chip)
        
        chip.isUserInteractionEnabled = false
        chip.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setSelectionStyle(isSelected: Bool) {
        chip.isSelected = isSelected
    }
}

// MARK: - Methods

extension NotificationFilterCVC {
    func initCell(type: NotificationFilterType) {
        chip.chipTitle = type.rawValue
        filterType = type
    }
}
