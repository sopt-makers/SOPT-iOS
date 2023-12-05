//
//  PokeProfileListView.swift
//  PokeFeature
//
//  Created by sejin on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core

public final class PokeProfileListView: UIView {
    
    // MARK: - Properties
    
    lazy var kokButtonTap: Driver<Void> = kokButton.tap
    
    var viewType: ProfileListType
    
    // MARK: - UI Components
    
    private let profileImageView = PokeProfileImageView()
    
    private lazy var kokButton = PokeKokButton()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray30.color
        label.font = UIFont.MDS.heading7
        return label
    }()
    
    private let partLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray300.color
        label.font = UIFont.MDS.label5
        return label
    }()
    
    private let kokCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray30.color
        label.font = UIFont.MDS.heading7
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.gray800.color
        view.isHidden = true
        return view
    }()
    
    // MARK: - initialization
    
    init(viewType: ProfileListType) {
        self.viewType = viewType
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(profileImageView, nameLabel, partLabel, kokCountLabel, kokButton, dividerView)
        
        self.viewType == .main ? setLayoutWithMainType() : setLayoutWithDefaultType()
    }
    
    private func setLayoutWithMainType() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        partLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
        }
        
        partLabel.snp.contentCompressionResistanceHorizontalPriority = 249
        
        kokCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(partLabel.snp.trailing).offset(8)
            make.trailing.equalTo(kokButton.snp.leading).offset(-12)
        }
        
        kokCountLabel.snp.contentCompressionResistanceHorizontalPriority = 1000
        
        kokButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setLayoutWithDefaultType() {
        self.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        partLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }
        
        partLabel.snp.contentCompressionResistanceHorizontalPriority = 249
        
        kokCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(partLabel.snp.trailing).offset(8)
            make.trailing.equalTo(kokButton.snp.leading).offset(-14)
        }
        
        kokCountLabel.snp.contentCompressionResistanceHorizontalPriority = 1000
        
        kokButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Methods
    
    @discardableResult
    func setData(imageURL: String, relation: PokeRelation, name: String, part: String, kokCount: Int) -> Self {
        self.profileImageView.setImage(with: imageURL, relation: relation)
        self.nameLabel.text = name
        self.partLabel.text = part
        self.kokCountLabel.text = "\(kokCount)콕"
        
        return self
    }
    
    @discardableResult
    func setButtonIsEnabled(to isEnabled: Bool) -> Self {
        self.kokButton.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func setBackgroundColor(with color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func setDividerViewIsHidden(to isHidden: Bool) -> Self {
        self.dividerView.isHidden = isHidden
        return self
    }
    
    @discardableResult
    func setIsFriend(to isFriend: Bool) -> Self {
        self.kokButton.isFriend = isFriend
        return self
    }
}

extension PokeProfileListView {
    enum ProfileListType {
        case main
        case `default`
    }
}
