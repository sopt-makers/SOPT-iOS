//
//  ProfileCardGroupView.swift
//  PokeFeature
//
//  Created by sejin on 12/8/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

public final class ProfileCardGroupView: UIView {
    
    // MARK: - Properties
    
    typealias UserId = String
    
    lazy var kokButtonTap: Driver<UserId?> = leftProfileCardView.kokButtonTap
        .merge(with: rightProfileCardView.kokButtonTap)
        .asDriver()
    
    let cancelBag = CancelBag()
        
    // MARK: - UI Components
    
    private let friendProfileImageView = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = DSKitAsset.Colors.gray700.color
        $0.clipsToBounds = true
    }
    
    private let friendNameLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.font = UIFont.MDS.title7
    }
    
    private let leftProfileCardView = PokeProfileCardView(frame: .zero)
    
    private let rightProfileCardView = PokeProfileCardView(frame: .zero)
    
    private lazy var profileCardStackView = UIStackView().then {
        $0.addArrangedSubviews(leftProfileCardView, rightProfileCardView)
        $0.axis = .horizontal
        $0.spacing = 32.adjusted
        $0.distribution = .fillEqually
    }
    
    // MARK: - initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension ProfileCardGroupView {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray900.color
        self.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        self.addSubviews(friendProfileImageView, friendNameLabel, profileCardStackView)
        
        friendProfileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(12)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        friendNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(friendProfileImageView)
            make.leading.equalTo(friendProfileImageView.snp.trailing).offset(8)
            make.trailing.greaterThanOrEqualToSuperview().inset(8)
        }
        
        leftProfileCardView.snp.makeConstraints { make in
            make.width.equalTo(130)
        }
        
        profileCardStackView.snp.makeConstraints { make in
            make.top.equalTo(friendProfileImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }
}

// MARK: - Methods

extension ProfileCardGroupView {
    func setProfileCard(with models: [ProfileCardContentModel], friendName: String) {
        self.friendNameLabel.text = friendName
        
        let models = models.prefix(2)
        for (index, model) in models.enumerated() {
            index == 0 ? leftProfileCardView.setData(with: model) : rightProfileCardView.setData(with: model)
        }
    }
}
