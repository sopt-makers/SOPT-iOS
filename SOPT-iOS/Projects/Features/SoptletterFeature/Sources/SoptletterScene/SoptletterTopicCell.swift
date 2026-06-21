//
//  SoptletterTopicCell.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/21/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//
 
import UIKit

import DSKit

final class SoptletterTopicCell: UITableViewCell {
 
    static let identifier = "SoptletterTopicCell"
 
    private let containerView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 12
    }
 
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
    }
 
    private let chevronImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.chevronRight.image
        $0.tintColor = DSKitAsset.Colors.gray200.color
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
        containerView.addSubviews(titleLabel, chevronImageView)
 
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
 
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }	
 
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
    }
 
    func configure(title: String) {
        titleLabel.text = title
    }
}
