//
//  SoptletterTopicCell.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/21/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import MDS

final class SoptletterTopicListCell: UITableViewCell, UITableViewRegisterable {

    static var isFromNib: Bool = false

    private let containerView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.subtle
        $0.layer.cornerRadius = BaseRadius.Base.r10
    }
    
    private let textContainerView = UIView()
    
    private lazy var infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
    }
    
    private lazy var badgeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private let titleLabel = UILabel().then {
        $0.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setTypography(Typography.label3, textColor: DSKitAsset.Colors.gray40.color)
    }
    
    private lazy var hotBadge = MDSTag(text: "HOT🔥", size: .small, shape: .pill, variant: .primary, style: .subtle)
    private lazy var newBadge = MDSTag(text: "NEW!", size: .small,shape: .pill, variant: .secondary, style: .subtle)
    private lazy var countLabel = UILabel().then {
        $0.setTypography(Typography.label3, textColor: SemanticColor.Fg.Brand.default)
    }
    private lazy var alarmIcon = UIView().then {
        $0.layer.cornerRadius = 6 / 2
        $0.clipsToBounds = true
        $0.backgroundColor = DSKitAsset.Colors.green400.color
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = MDSIcon.chevronRightOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold)
        $0.contentMode = .scaleAspectFit
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews(textContainerView, infoStackView, chevronImageView)
        infoStackView.addArrangedSubviews(badgeStackView, alarmIcon)
        textContainerView.addSubviews(titleLabel, descriptionLabel)
        badgeStackView.addArrangedSubviews(hotBadge, newBadge, countLabel)

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.height.equalTo(68)
            make.bottom.equalToSuperview().inset(BaseSpacing.Base.s10)
        }

        textContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview()
        }
        
        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(textContainerView.snp.trailing).offset(11)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        
        alarmIcon.snp.makeConstraints { make in
            make.width.height.equalTo(6)
        }

        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }

    func configure(
        title: String,
        description: String,
        isHot: Bool,
        isNew: Bool,
        count: Int
    ) {
        titleLabel.text = title
        titleLabel.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold)
        descriptionLabel.text = description
        descriptionLabel.setTypography(Typography.label3, textColor: DSKitAsset.Colors.gray40.color)
        
        let hasNewCount = count > 0
        let hasBadge = isHot || isNew

        hotBadge.isHidden = !isHot
        newBadge.isHidden = !isNew
        countLabel.isHidden = !(hasNewCount && !hasBadge)
        alarmIcon.isHidden = !hasNewCount
        countLabel.text = "\(count)개"
    }
}
