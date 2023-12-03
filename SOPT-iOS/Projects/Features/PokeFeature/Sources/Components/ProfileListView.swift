//
//  ProfileListView.swift
//  PokeFeature
//
//  Created by sejin on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core

public final class ProfileListView: UIView {
    
    // MARK: - Properties
    
    lazy var kokButtonTap: Driver<Void> = kokButton.tap
    
    var viewType: ProfileListType
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = DSKitAsset.Colors.gray700.color
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let kokButton = KokButton()
    
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
        self.profileImageView.layer.cornerRadius = self.viewType == .main ? 20 : 25
    }
    
    private func setLayout() {
        self.addSubviews(profileImageView, nameLabel, partLabel, kokCountLabel, kokButton)
        
        self.viewType == .main ? setLayoutWithMainType() : setLayoutWithDefaultType()
    }
    
    private func setLayoutWithMainType() {
        self.snp.makeConstraints { make in
            make.width.equalTo(311)
            make.height.equalTo(44)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        partLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
        }
        
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
    }
    
    private func setLayoutWithDefaultType() {
        self.snp.makeConstraints { make in
            make.width.equalTo(375)
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
    }
    
    // MARK: - Methods
    
    @discardableResult
    func setData(image: UIImage, name: String, part: String, kokCount: Int) -> Self {
        self.profileImageView.image = image
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
}

extension ProfileListView {
    enum ProfileListType {
        case main
        case `default`
    }
}
