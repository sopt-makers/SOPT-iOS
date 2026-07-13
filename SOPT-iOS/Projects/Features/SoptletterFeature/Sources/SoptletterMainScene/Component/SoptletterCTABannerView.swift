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

final class SoptletterCTABannerView: UIView {

    // MARK: - UI

    private let iconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icMailBox.image
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.text = "이번 기수 회고하러 가볼까요?"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }

    private let chevronImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.chevronRight.image
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        addTapGesture()
    }

    func setLayout() {
        self.addSubviews(iconImageView, titleLabel, chevronImageView)

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-8)
        }

        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }

        self.snp.makeConstraints {
            $0.height.equalTo(64)
        }
    }
}

// MARK: - UIView + addSubviews (프로젝트에 이미 있다면 중복 정의 제거)

private extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
