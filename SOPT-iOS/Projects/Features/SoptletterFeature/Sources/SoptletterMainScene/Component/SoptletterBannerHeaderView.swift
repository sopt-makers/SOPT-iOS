//
//  SoptletterBannerHeaderView.swift
//  SoptletterFeature
//
//  Created by dev on 7/13/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import SnapKit

import Core
import DSKit
import MDS

final class SoptletterBannerHeaderView: UICollectionReusableView, UICollectionReusableViewRegisterable {

    static var isFromNib: Bool = false

    private enum Metric {
        static let bannerHeight: CGFloat = 64
        static let iconSize: CGFloat = 40
        static let chevronSize: CGFloat = 24
    }

    // MARK: - UI Components

    private let bannerView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.ghost
        $0.layer.cornerRadius = BaseRadius.Base.r12
        $0.layer.masksToBounds = true
    }

    private let iconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icMailBox.image
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel()

    private let chevronImageView = UIImageView().then {
        $0.image = MDSIcon.chevronRightOutlined.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = SemanticColor.Fg.Neutral.bold
        $0.contentMode = .scaleAspectFit
    }

    private var bannerHeightConstraint: Constraint?

    // MARK: - Tap Handling

    var onTap: (() -> Void)?

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

    func configure(ctaText: String, isHidden: Bool, onTap: (() -> Void)?) {
        titleLabel.text = ctaText
        titleLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)
        self.onTap = onTap

        bannerView.isHidden = isHidden
        bannerHeightConstraint?.update(offset: isHidden ? 0 : Metric.bannerHeight)
        bannerView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(isHidden ? BaseSpacing.Base.s0 : BaseSpacing.Base.s12)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onTap = nil
    }

    @objc
    private func didTapBanner() {
        onTap?()
    }
}

// MARK: - UI & Layout

private extension SoptletterBannerHeaderView {

    func setStyle() {
        bannerView.isUserInteractionEnabled = true
        bannerView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapBanner))
        )
    }

    func setLayout() {
        addSubview(bannerView)
        bannerView.addSubviews(iconImageView, titleLabel, chevronImageView)

        bannerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(BaseSpacing.Base.s12)
            bannerHeightConstraint = make.height.equalTo(Metric.bannerHeight).constraint
        }

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s10)
            make.centerY.equalToSuperview()
            make.size.equalTo(Metric.iconSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(BaseSpacing.Base.s8)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-BaseSpacing.Base.s8)
        }

        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(BaseSpacing.Base.s10)
            make.centerY.equalToSuperview()
            make.size.equalTo(Metric.chevronSize)
        }
    }
}
