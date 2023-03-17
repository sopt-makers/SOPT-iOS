//
//  SettingHeaderView.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core
import DSKit

class SettingHeaderView: UICollectionReusableView, UICollectionReusableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray50.color
        self.titleLabel.textColor = DSKitAsset.Colors.gray500.color
        self.titleLabel.setTypoStyle(.caption1)
        self.titleLabel.text = "내 정보"
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    // MARK: - Methods
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
}
