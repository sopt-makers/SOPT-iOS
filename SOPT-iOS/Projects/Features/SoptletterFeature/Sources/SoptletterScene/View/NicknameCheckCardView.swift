//
//  NicknameCheckCardView.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/21/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import MDS
import Core

final class NicknameCheckCardView: UIView {
    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = DSKitAsset.Assets.imgNicknameCheck.image
        return iv
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "nn" + I18N.Soptletter.Nickname.descriptionText
        label.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.default)
        label.textAlignment = .center
        return label
    }()

    private let divider: UIView = {
       let view = UIView()
        view.backgroundColor = SemanticColor.Stroke.Neutral.default
        return view
    }()

    private let myNickName: UILabel = {
       let label = UILabel()
        label.text = I18N.Soptletter.Nickname.myNicknameText
        label.setTypography(Typography.title3,
                            textColor: SemanticColor.Fg.Neutral.subtle)
        return label
    }()

    private let userNickName: UILabel = {
        let label = UILabel()
        label.text = "익명의 김솝트"
        label.setTypography(Typography.title2, textColor: SemanticColor.Fg.Neutral.bold)
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
        backgroundColor = SemanticColor.Bg.Neutral.ghost
        self.layer.cornerRadius = BaseRadius.Base.r12
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
            $0.top.equalToSuperview().inset(BaseSpacing.Base.s28)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(BaseSpacing.Base.s20)
            $0.centerX.equalToSuperview()
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(BaseSpacing.Base.s16)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s12)
        }
        myNickName.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(BaseSpacing.Base.s16)
            $0.centerX.equalToSuperview()
        }
        userNickName.snp.makeConstraints {
            $0.top.equalTo(myNickName.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(BaseSpacing.Base.s32)
        }
    }
}

extension NicknameCheckCardView {
    func configure(nickName: String, number: Int) {
        descriptionLabel.text = String(number) + I18N.Soptletter.Nickname.descriptionText
        descriptionLabel.setTypography(Typography.title4,
                                       textColor: SemanticColor.Fg.Neutral.default,
                                       alignment: .center)
        userNickName.text = nickName
        userNickName.setTypography(Typography.title2, textColor: SemanticColor.Fg.Neutral.bold)
   }
}
