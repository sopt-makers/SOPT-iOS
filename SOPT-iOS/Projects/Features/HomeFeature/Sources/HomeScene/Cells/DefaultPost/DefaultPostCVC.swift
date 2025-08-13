//
//  DefaultPostCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import Core
import DSKit

enum PopularPostsCVCStatus {
    case focusing
    case unfocusing
}

enum PopularPostCategory: String, CaseIterable {
    case first = "실시간 인기 1위"
    case second = "실시간 인기 2위"
    case third = "실시간 인기 3위"
}

enum PostCellType {
    case popular
    case latest
    case empty
}

final class DefaultPostCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    var onAnimationCompleted: (() -> Void)?
    private var isOutlineAnimationCancelled = false
        
    // MARK: - UI & Layout

    private let categorySubPhraseView = HomeCategoryTagLabel().setTitleColor(DSKitAsset.Colors.orange300.color)

    private let verticalDividerView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icVerticalDivider.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let categoryTagView = HomeCategoryTagLabel().setTitleColor(DSKitAsset.Colors.orange300.color)
    
    private let profileImageView = CustomProfileImageView().hideBorder()
    
    private let userNameLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 10)
        $0.textAlignment = .center
    }
    
    private let userPartLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 10)
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
    }
    
    private let userStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let postTitleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    private let postContentLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.numberOfLines = 2
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 6
    }
    
    // 엠티 뷰일 경우
    private let emptyTitleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    private let emptySubLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.textColor = DSKitAsset.Colors.gray300.color
    }
    
    private let emptyImageView = CustomProfileImageView().hideBorder()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setStackView()
        setLayout()
        setEmptyViewLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.numberOfLines = 1
        userNameLabel.lineBreakMode = .byTruncatingTail
        userNameLabel.text = nil
        userPartLabel.text = nil
        postTitleLabel.text = nil
        postContentLabel.text = nil
        emptySubLabel.text = nil
        emptyTitleLabel.text = nil
        emptyImageView.image = nil
        profileImageView.setPlaceholder()
    }
}

// MARK: - UI & Layout

extension DefaultPostCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        self.layer.cornerRadius = 12
    }

    private func setLayout() {
        self.addSubviews(userStackView, contentStackView)

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        userStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(userStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(22)
            make.top.equalToSuperview().inset(21)
        }
    }
    
    private func setStackView() {
        categoryStackView.addArrangedSubviews(
            categorySubPhraseView,
            verticalDividerView,
            categoryTagView
        )
        
        verticalDividerView.snp.makeConstraints { make in
            make.height.equalTo(7)
        }
        
        verticalDividerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        verticalDividerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        userStackView.addArrangedSubviews(
            profileImageView,
            userNameLabel,
            userPartLabel
        )
        
        userStackView.setCustomSpacing(5, after: profileImageView)
        userStackView.setCustomSpacing(1, after: userNameLabel)
        
        contentStackView.addArrangedSubviews(
            categoryStackView,
            postTitleLabel,
            postContentLabel
        )
    }
    
    /// Border가 있는 경우, gradient가 존재합니다.
    private func setGradientBorder() {
        let borderWidth: CGFloat = 1
        let cornerRadius: CGFloat = 12

        gradientLayer.frame = bounds

        let rect = bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.frame = bounds

        // 그라데이션 색상 설정
        gradientLayer.colors = [
            DSKitAsset.Colors.orange300.color.cgColor,
            DSKitAsset.Colors.orange200.color.cgColor,
            DSKitAsset.Colors.orange500.color.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.mask = shapeLayer
        gradientLayer.opacity = 0

        if gradientLayer.superlayer == nil {
            layer.addSublayer(gradientLayer)
        }
    }
    
    // 최신글이 없을 경우 띄워지는 엠티뷰입니다.
    private func setEmptyViewLayout() {
        self.addSubviews(emptySubLabel, emptyTitleLabel, emptyImageView)
        
        emptySubLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(38)
            make.leading.equalToSuperview().inset(28)
        }
        
        emptyTitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(38)
            make.leading.equalTo(emptySubLabel.snp.leading)
        }
        
        emptyImageView.snp.remakeConstraints { make in
            make.size.equalTo(64)
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
    
    private func changeTitleLabelColor(for target: String) {
        self.emptyTitleLabel.partColorChange(
            targetString: "[\(target)]",
            textColor: DSKitAsset.Colors.orange300.color
        )
    }
    
    private func updateVisibility(for cellType: PostCellType) {
        switch cellType {
        case .popular, .latest:
            self.userStackView.isHidden = false
            self.contentStackView.isHidden = false

            self.emptyTitleLabel.isHidden = true
            self.emptySubLabel.isHidden = true
            self.emptyImageView.isHidden = true
        case .empty:
            self.emptyTitleLabel.isHidden = false
            self.emptySubLabel.isHidden = false
            self.emptyImageView.isHidden = false
            
            self.userStackView.isHidden = true
            self.contentStackView.isHidden = true
        }
    }
}

// MARK: - Methods

extension DefaultPostCVC {
    func configureCell(model: some PostDisplayable, index: IndexPath, cellType: PostCellType) {
        // NOTE: 사용자의 이름 값이 존재하지 않을 경우, 엠티뷰 레이아웃이 그려집니다.
        if let name = model.name {
            self.userNameLabel.text = name
            updateVisibility(for: cellType)
        } else {
            self.emptySubLabel.text = model.title
            self.emptyTitleLabel.text = "[\(model.category)]\(model.content)"
            changeTitleLabelColor(for: model.category)
            self.emptyImageView.setImage(with: model.profileImage ?? "")
            updateVisibility(for: .empty)
            return
        }
        
        self.categoryTagView.setData(with: model.category)
        self.userNameLabel.text = model.name ?? ""
            
        let part = model.generationAndPart
        if let part, !part.isEmpty {
            // 익명이 아닐 경우
            self.userPartLabel.isHidden = false
            self.userPartLabel.text = part
            self.userNameLabel.numberOfLines = 1
            self.userNameLabel.lineBreakMode = .byTruncatingTail
        } else {
            // 익명일 경우
            self.userPartLabel.isHidden = true
            self.userNameLabel.numberOfLines = 2
            self.userNameLabel.lineBreakMode = .byWordWrapping
        }
        
        switch cellType {
        case .latest:
            self.categorySubPhraseView.setData(with: "NEW")
        case .popular:
            if let category = PopularPostCategory.allCases[safe: index.row] {
                self.categorySubPhraseView.setData(with: category.rawValue)
            }
        default: return
        }
        
        if let profileImage = model.profileImage {
            self.profileImageView.setImage(with: profileImage, placeholder: DSKitAsset.Assets.iconDefaultProfile.image)
        }
        self.postTitleLabel.text = model.title
        self.postContentLabel.text = model.content
        self.postContentLabel.setLineSpacing(lineSpacing: 1)
    }
}


// MARK: - Animation Methods

extension DefaultPostCVC {
    /// 애니메이션 중단 메서드
    func cancelOutlineAnimation() {
        isOutlineAnimationCancelled = true
        gradientLayer.removeAllAnimations()
        gradientLayer.opacity = 0
        onAnimationCompleted = nil
    }
    
    /// 0.3초간 show -> 2.4초 기다림 -> 0.3초간 hide
    func setOutlinedAnimated() {
        isOutlineAnimationCancelled = false
        let interval = 2.4
        animateBorderOpacity(to: 1) { [weak self] in
            guard let self = self, !self.isOutlineAnimationCancelled else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                guard !self.isOutlineAnimationCancelled else { return }
                self.animateBorderOpacity(to: 0) { [weak self] in
                    guard let self = self, !self.isOutlineAnimationCancelled else { return }
                    self.onAnimationCompleted?()
                    cancelOutlineAnimation()
                }
            }
        }
    }

    private func animateBorderOpacity(to value: Float, completion: @escaping () -> Void) {
        guard !isOutlineAnimationCancelled else { return }
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = gradientLayer.presentation()?.opacity ?? gradientLayer.opacity
        animation.toValue = value
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if !self.isOutlineAnimationCancelled {
                completion()
            }
        }
        gradientLayer.add(animation, forKey: "opacity")
        gradientLayer.opacity = value
        CATransaction.commit()
    }
}
