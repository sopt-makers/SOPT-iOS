//
//  PokeProfileCardView.swift
//  PokeFeature
//
//  Created by sejin on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core
import Domain

public final class PokeProfileCardView: UIView, PokeCompatible {
    
    // MARK: - Properties
       
    lazy var profileTapped = self.profileImageView.gesture().map { _ in self.user }.asDriver()

    lazy var kokButtonTap: Driver<PokeUserModel?> = kokButton.tap.map { self.user }.asDriver()
    
    var user: PokeUserModel?
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = DSKitAsset.Colors.gray700.color
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let kokButton = PokeKokButton()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray30.color
        label.font = UIFont.MDS.body3
        return label
    }()
    
    private let partLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray300.color
        label.font = UIFont.MDS.label5
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, partLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, labelStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
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
            make.height.equalTo(120)
            make.width.equalTo(120)
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
        self.profileImageView.setImage(with: model.profileImage, placeholder: DSKitAsset.Assets.iconDefaultProfile.image)
        self.nameLabel.text = model.name
        self.partLabel.text = String(describing: model.generation) + "기" + " " + model.part
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
