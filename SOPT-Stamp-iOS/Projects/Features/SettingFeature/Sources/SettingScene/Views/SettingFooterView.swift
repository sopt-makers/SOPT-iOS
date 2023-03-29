//
//  SettingFooterView.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core
import DSKit

protocol WithdrawButtonDelegate: AnyObject {
    func withdrawButtonTapped()
}

class SettingFooterView: UICollectionReusableView, UICollectionReusableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    public var buttonDelegate: WithdrawButtonDelegate?
    
    // MARK: - UI Components
    
    private let withdrawButton = UIButton()
    private let underLineView = UIView()
    
    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
        self.setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.withdrawButton.setTitle(I18N.Setting.withdraw, for: .normal)
        self.withdrawButton.setTitleColor(DSKitAsset.Colors.soptampGray400.color, for: .normal)
        self.withdrawButton.titleLabel?.setTypoStyle(.SoptampFont.caption1D)
        
        self.underLineView.backgroundColor = DSKitAsset.Colors.soptampGray400.color
    }
    
    private func setLayout() {
        self.addSubviews(underLineView, withdrawButton)
        
        withdrawButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints { make in
            make.bottom.equalTo(withdrawButton.snp.bottom).inset(4)
            make.trailing.equalTo(withdrawButton.snp.trailing)
            make.width.equalTo(withdrawButton.snp.width)
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Methods
    
    private func setAddTarget() {
        self.withdrawButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc
    private func buttonTapped() {
        self.buttonDelegate?.withdrawButtonTapped()
    }
}
