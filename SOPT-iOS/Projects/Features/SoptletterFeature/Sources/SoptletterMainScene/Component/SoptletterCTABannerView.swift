//
//  SoptletterCTABannerView.swift
//  SoptletterFeature
//
//  Created by dev on 7/13/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import SnapKit

import DSKit
import MDS

// TODO: - 디자인 반영 안됨
final class SoptletterCTABannerView: UIView {

    // MARK: - UI

    private let iconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icMailBox.image
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel()

    private let chevronImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.chevronRight.image
        $0.tintColor = SemanticColor.Fg.Neutral.bold
        $0.contentMode = .scaleAspectFit
    }

    private var heightConstraint: Constraint?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(text: String) {
        titleLabel.text = text
        titleLabel.setTypography(Typography.heading4, textColor: SemanticColor.Fg.Neutral.bold)
    }

    func setCollapsed(_ collapsed: Bool) {
        self.isHidden = collapsed
        heightConstraint?.update(offset: collapsed ? 0 : 64)
    }

    // MARK: - Tap Handling

    var onTap: (() -> Void)?

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }

    @objc
    private func didTapView() {
        onTap?()
    }
}

// MARK: - UI Setting

private extension SoptletterCTABannerView {

    func setStyle() {
        self.backgroundColor = SemanticColor.Bg.Neutral.ghost
        self.layer.cornerRadius = BaseRadius.Base.r12
        self.layer.masksToBounds = true
        addTapGesture()
    }

    func setLayout() {
        self.addSubviews(iconImageView, titleLabel, chevronImageView)

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(BaseSpacing.Base.s16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(BaseSpacing.Base.s12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-BaseSpacing.Base.s8)
        }

        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSpacing.Base.s16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }

        self.snp.makeConstraints {
            heightConstraint = $0.height.equalTo(64).constraint
        }
    }
}
