//
//  DailySoptuneResultPokeView.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit
import Core
import Domain

public final class DailySoptuneResultPokeView: UIView {
    
    public lazy var kokButtonTap: Driver<PokeUserModel?> = kokButton.tap
        .map { self.user }
        .asDriver()
    
    lazy var profileTap = self.profileImageView.gesture()
        .filter { [weak self] _ in self?.user?.isAnonymous == false }
        .map { [weak self] _ in self?.user }.asDriver()
    
    // MARK: - Properties
    
    var user: PokeUserModel?
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.MDS.body3R.font
        $0.textColor = DSKitAsset.Colors.gray100.color
        $0.text = I18N.DailySoptune.poke
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.MDS.title5.font
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.text = I18N.DailySoptune.pokeFortunatePerson
    }
    
    private let profileImageView = CustomProfileImageView()
    
    private let nameLabel = UILabel().then {
        $0.font = UIFont.MDS.body1.font
        $0.textColor = DSKitAsset.Colors.gray30.color
    }
    
    private let partLabel = UILabel().then {
        $0.font = UIFont.MDS.label4.font
        $0.textColor = DSKitAsset.Colors.gray300.color
    }
    
    private let kokButton = PKokButton()
    
    private lazy var labelStackView = UIStackView(
        arrangedSubviews: [nameLabel, partLabel]
    ).then {
        $0.axis = .vertical
        $0.spacing = 2
        $0.alignment = .leading
    }
    
    private lazy var pokeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    // MARK: - initialization
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setStackView()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension DailySoptuneResultPokeView {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray900.color
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
    
    private func setStackView() {
        pokeStackView.addArrangedSubviews(
            profileImageView, labelStackView, kokButton
        )
        
        pokeStackView.setCustomSpacing(10, after: profileImageView)
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel, subTitleLabel, pokeStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(72)
        }
        
        kokButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        
        pokeStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(pokeStackView.snp.bottom).offset(28)
        }
    }
}

// MARK: - Methods

extension DailySoptuneResultPokeView {
    
    func setData(with model: PokeUserModel) {
        self.configure(with: model)
    }
    
    func changeUIAfterPoke(newUserModel: PokeUserModel) {
        guard let user, user.userId == newUserModel.userId else { return }
        self.setData(with: newUserModel)
    }
    
    private func configure(with model: PokeUserModel) {
        self.user = model
        self.nameLabel.text = model.name
        self.partLabel.text = "\(model.generation)기 \(model.part)"
        self.profileImageView.setImage(with: model.profileImage)
        self.profileImageView.layer.borderWidth = 0
        self.kokButton.isEnabled = !model.isAlreadyPoke
    }
    
}
