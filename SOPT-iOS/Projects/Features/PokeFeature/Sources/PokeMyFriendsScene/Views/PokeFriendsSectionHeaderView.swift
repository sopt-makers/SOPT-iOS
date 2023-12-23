//
//  PokeFriendsSectionHeaderView.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit
import Core

public final class PokeFriendsSectionHeaderView: UIView {
    
    // MARK: - Properties
    
    public lazy var rightButtonTap: Driver<Void> = rightButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.MDS.heading6
        $0.textColor = DSKitAsset.Colors.gray10.color
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = UIFont.MDS.label4
        $0.textColor = DSKitAsset.Colors.gray200.color
    }
    
    private let friendsCountLabel = UILabel().then {
        $0.font = UIFont.MDS.body3R
        $0.textColor = DSKitAsset.Colors.white.color
    }
    
    private let rightButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.iconChevronRight.image.withTintColor(DSKitAsset.Colors.white.color),
                    for: .normal)
    }
    
    // MARK: - initialization
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokeFriendsSectionHeaderView {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel, descriptionLabel, friendsCountLabel, rightButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        friendsCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(descriptionLabel.snp.trailing).offset(4)
            make.trailing.equalTo(rightButton.snp.leading).offset(-8)
        }
        
        rightButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
}

extension PokeFriendsSectionHeaderView {
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        self.titleLabel.text = title
        return self
    }
    
    @discardableResult
    public func setDescription(_ description: String) -> Self {
        self.descriptionLabel.text = description
        return self
    }
    
    @discardableResult
    public func setFriendsCount(_ count: Int) -> Self {
        self.friendsCountLabel.text = "\(count)명"
        return self
    }
    
    @discardableResult
    public func setRightButtonImage(with image: UIImage) -> Self {
        self.rightButton.setImage(image, for: .normal)
        return self
    }}
