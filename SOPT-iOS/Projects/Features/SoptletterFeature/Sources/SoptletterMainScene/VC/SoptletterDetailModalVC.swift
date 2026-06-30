//
//  SoptletterDetailVC.swift
//  SoptletterFeature
//
//  Created by dev on 6/29/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import SnapKit
import Then

import DSKit

public final class SoptletterDetailModalVC: UIViewController {

    private let dimmedView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private let nameLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray600.color
    }

    private let contentScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }

    private let contentLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.regular.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray600.color
        $0.numberOfLines = 0
    }

    private let dateLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray300.color
    }

    private let likeImageView = UIImageView().then {
        $0.image = UIImage(systemName: "heart")
        $0.tintColor = DSKitAsset.Colors.gray700.color
        $0.contentMode = .scaleAspectFit
    }

    private let likeCountLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.textColor = DSKitAsset.Colors.gray700.color
    }

    private let likeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 12
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }

    @discardableResult
    func configure(
        backgroundColor: UIColor = DSKitAsset.Colors.blue50.color,
        name: String,
        content: String,
        date: String,
        likeCount: Int
    ) -> Self {
        containerView.backgroundColor = backgroundColor
        nameLabel.text = name
        contentLabel.text = content
        dateLabel.text = date
        likeCountLabel.text = "\(likeCount)"
        return self
    }
}

private extension SoptletterDetailModalVC {
    func setUI() {
        view.backgroundColor = .clear
    }

    func setLayout() {
        likeStackView.addArrangedSubviews(likeImageView, likeCountLabel)
        contentScrollView.addSubview(contentLabel)
        containerView.addSubviews(nameLabel, contentScrollView, dateLabel, likeStackView, confirmButton)
        view.addSubviews(dimmedView, containerView)

        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(19)
            make.center.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
        }

        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(312)
        }

        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(contentScrollView)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentScrollView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
        }

        likeStackView.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(20)
        }

        likeImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
    }

    func setAddTarget() {
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedViewDidTap)))
    }

    @objc func confirmButtonDidTap() {
        dismiss(animated: true)
    }

    @objc func dimmedViewDidTap() {
        dismiss(animated: true)
    }
}
