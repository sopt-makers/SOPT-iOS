//
//  SelectTopicDropDownCell.swift
//  SoptletterFeature
//
//  Created by 이나연 on 10/14/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Then
import Core
import DSKit
import MDS

final class SelectTopicDropDownCell: UITableViewCell, UITableViewRegisterable {
    
    static let isFromNib: Bool = false
    
    private let containerView = UIView()
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    private lazy var hotBadge = MDSTag(text: "HOT🔥", size: .small, shape: .pill, variant: .primary, style: .subtle)
    private lazy var newBadge = MDSTag(text: "NEW!", size: .small,shape: .pill, variant: .secondary, style: .subtle)
    
    private let titleLabel = UILabel().then {
        $0.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setTypography(Typography.body3, textColor: SemanticColor.Fg.Neutral.subtle)
    }
    
    private let checkIcon = UIImageView().then {
        $0.image = MDSIcon.checkOutlined.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = SemanticColor.Bg.Secondary.default
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
        contentView.addSubviews(containerView, checkIcon)
        
        containerView.addSubviews(titleStackView, descriptionLabel)
        titleStackView.addArrangedSubviews(hotBadge, newBadge, titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(BaseSpacing.Base.s10)
            make.trailing.equalToSuperview().inset(44)
            make.height.equalTo(66)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(2)
            make.leading.equalToSuperview()
        }
        
        checkIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(BaseSpacing.Base.s10)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
    }
}

extension SelectTopicDropDownCell {
    func configure(
        title: String,
        description: String,
        isHot: Bool,
        isNew: Bool,
        isSelected: Bool
    ) {
        titleLabel.text = title
        titleLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
        descriptionLabel.text = description
        descriptionLabel.setTypography(Typography.body3, textColor: SemanticColor.Fg.Neutral.subtle)
        
        hotBadge.isHidden = !isHot
        newBadge.isHidden = !isNew
        
        checkIcon.isHidden = !isSelected
        contentView.backgroundColor = isSelected ? SemanticColor.Bg.Neutral.ghost : .clear
        contentView.layer.cornerRadius = 8
    }
}
