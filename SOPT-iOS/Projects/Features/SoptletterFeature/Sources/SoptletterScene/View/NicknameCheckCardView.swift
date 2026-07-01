//
//  NicknameCheckCardView.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/21/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core

final class NicknameCheckCardView: UIView {
    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = DSKitAsset.Assets.imgNicknameCheck.image
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "nn" + I18N.Soptletter.Nickname.descriptionText
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = DSKitAsset.Colors.gray50.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider: UIView = {
       let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.gray600.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myNickName: UILabel = {
       let label = UILabel()
        label.text = I18N.Soptletter.Nickname.myNicknameText
        label.textColor = DSKitAsset.Colors.gray300.color
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 20)
        return label
    }()
    
    private let userNickName: UILabel = {
        let label = UILabel()
        label.text = "익명의 김솝트"
         label.textColor = DSKitAsset.Colors.gray30.color
         label.font = DSKitFontFamily.Suit.semiBold.font(size: 24)
         return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NicknameCheckCardView {
    private func setUI() {
        backgroundColor = DSKitAsset.Colors.gray800.color
        self.layer.cornerRadius = 12
    }
    
    private func setLayout() {
        addSubviews(
            imageView,
            descriptionLabel,
            divider,
            myNickName,
            userNickName
        )
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        myNickName.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        userNickName.snp.makeConstraints {
            $0.top.equalTo(myNickName.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(34)
        }
    }
}

extension NicknameCheckCardView {
    func configure(nickName: String, number: Int) {
        descriptionLabel.text = String(number) + I18N.Soptletter.Nickname.descriptionText
        userNickName.text = nickName
    }
}
