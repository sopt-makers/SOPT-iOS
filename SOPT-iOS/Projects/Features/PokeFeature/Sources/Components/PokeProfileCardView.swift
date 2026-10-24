//
//  PokeProfileCardView.swift
//  PokeFeature
//
//  Created by sejin on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import MDS
import Core
import Domain

public final class PokeProfileCardView: UIView, PokeCompatible {
    
    // MARK: - Properties
       
    lazy var profileTapped = profileImageView.gesture()
        .withUnretained(self)
        .filter{ owner, _ in
            owner.user?.isAnonymous == false
        }
        .map{ owner, _ in
            owner.user
        }.asDriver()

    lazy var kokButtonTap: Driver<PokeUserModel?> = kokButton.tap
        .withUnretained(self)
        .map { owner, _ in
            owner.user
        }.asDriver()
    
    var user: PokeUserModel?
    
    // MARK: - UI Components
    
    private let profileImageView = MDSAvatar(size: 120, hasStroke: false)
    
    private let kokButton = PKokButton()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
        return label
    }()
    
    private let partLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, partLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, labelStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        self.addSubviews(containerStackView, kokButton)

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(120)
        }

        labelStackView.snp.makeConstraints { make in
            make.height.equalTo(38)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
        }
        
        kokButton.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(4)
        }
    }
    
    // MARK: - Methods

    func setData(with model: PokeUserModel) {
        self.user = model
        if !model.isAnonymous && !model.profileImage.isEmpty {
            self.profileImageView.setImage(with: model.profileImage)
        } else {
            self.profileImageView.image = nil
        }
        self.nameLabel.text = model.isAnonymous ? model.anonymousName : model.name
        self.nameLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
        self.partLabel.text = String(describing: model.generation) + "기" + " " + model.part
        self.partLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
        self.kokButton.isEnabled = !model.isAlreadyPoke
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
    
    func changeUIAfterPoke(newUserModel: PokeUserModel) {
        guard let user, user.userId == newUserModel.userId else { return }
        
        self.setData(with: newUserModel)
    }
}
