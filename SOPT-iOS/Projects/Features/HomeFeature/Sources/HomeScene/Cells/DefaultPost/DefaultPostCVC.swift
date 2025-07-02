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

enum PlaygroundNewsCardCVCStatus {
    case focusing
    case unfocusing
}

final class DefaultPostCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
        
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
        $0.font = DSKitFontFamily.Suit.regular.font(size: 10)
    }
    
    private let userPartLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 10)
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    private let userStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let postTitleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
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

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setStackView()
        setLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

// MARK: - Methods

extension DefaultPostCVC {
    func configureCell(model: some PostDisplayable) {
        self.categorySubPhraseView.setData(with: model.title)
        self.categoryTagView.setData(with: model.category)
        self.userNameLabel.text = model.name
        self.userPartLabel.text = model.name
        if let profileImage = model.profileImage {
            self.profileImageView.setImage(with: profileImage)
        }
        self.postTitleLabel.text = model.title
        self.postContentLabel.text = model.content
        self.postContentLabel.setLineSpacing(lineSpacing: 1)
    }
}


// MARK: - Animation Methods

extension DefaultPostCVC {
    /// 0.3초간 show -> 2.4초 기다림 -> 0.3초간 hide
    func setOutlinedAnimated() async {
        let interval = 2.4
        
        do {
            try Task.checkCancellation()
            await animateBorderOpacity(to: 1)
            
            try Task.checkCancellation()
            try await Task.sleep(for: .seconds(interval))
            
            try Task.checkCancellation()
            await animateBorderOpacity(to: 0)
        } catch {
            gradientLayer.opacity = 0 // 취소가 감지될 경우, 현재 그라디언트를 즉시 0으로 만듦
        }
    }
    
    private func animateBorderOpacity(to value: Float) async {
        do {
            try Task.checkCancellation()
            
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = gradientLayer.presentation()?.opacity ?? gradientLayer.opacity
            animation.toValue = value
            animation.duration = 0.3
            animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            
            gradientLayer.add(animation, forKey: "opacity")
            gradientLayer.opacity = value
            
            try await Task.sleep(for: .seconds(animation.duration)) // 애니메이션 동안 sleep
        } catch {
            return
        }
    }
}
