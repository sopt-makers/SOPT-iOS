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

final class SoptletterTopicCell: UITableViewCell, UITableViewRegisterable {

    static var isFromNib: Bool = false

    private let containerView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.subtle
        $0.layer.cornerRadius = BaseRadius.Base.r10
    }

    private let titleLabel = UILabel().then {
        $0.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold)
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
        containerView.addSubviews(titleLabel, chevronImageView)

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().inset(BaseSpacing.Base.s10)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.centerY.equalToSuperview()
        }

        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
