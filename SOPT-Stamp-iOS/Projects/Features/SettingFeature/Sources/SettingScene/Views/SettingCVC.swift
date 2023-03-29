//
//  SettingCVC.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core
import DSKit

class SettingCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let topLineView = UIView()
    private let bottomLineView = UIView()
    
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
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.soptampGray50.color
        
        titleLabel.setTypoStyle(.SoptampFont.subtitle1)
        titleLabel.textColor = DSKitAsset.Colors.soptampBlack.color        
        arrowImageView.image = UIImage(asset: DSKitAsset.Assets.icLeftArrow)
        
        topLineView.backgroundColor = DSKitAsset.Colors.soptampGray100.color
        bottomLineView.backgroundColor = DSKitAsset.Colors.soptampGray100.color
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel, arrowImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(6)
            make.width.height.equalTo(32)
        }
    }
    
    // MARK: - Method
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
    
    @discardableResult
    func removeArrow() -> Self {
        arrowImageView.isHidden = true
        return self
    }
    
    @discardableResult
    func changeTextColor(_ color: UIColor) -> Self {
        self.titleLabel.textColor = color
        return self
    }
    
    @discardableResult
    func setRadius(_ onlyBottom: Bool = true) -> Self {
        self.layer.cornerRadius = 12
        if onlyBottom {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        return self
    }
    
    @discardableResult
    func setLines() -> Self {
        self.addSubviews(topLineView, bottomLineView)
        
        topLineView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return self
    }
}
