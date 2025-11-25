//
//  SoptlogMenuCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogMenuCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 3
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        label.textColor = DSKitAsset.Colors.white.color
        return label
    }()
    
    private let tooltipButton: UIButton = {
        let button = UIButton()
        button.setImage(DSKitAsset.Assets.icInfo.image, for: .normal)
        button.tintColor = DSKitAsset.Colors.gray100.color
        button.isHidden = true
        return button
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        label.textColor = DSKitAsset.Colors.white.color
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.chevronRight.image
        imageView.tintColor = DSKitAsset.Colors.gray200.color
        imageView.isHidden = true
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.gray700.color
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SoptlogMenuCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews(leftStackView, rightStackView, separatorView)
        
        leftStackView.addArrangedSubview(titleLabel)
        leftStackView.addArrangedSubview(tooltipButton)
        
        rightStackView.addArrangedSubview(valueLabel)
        rightStackView.addArrangedSubview(chevronImageView)
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        rightStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(13)
            make.centerY.equalToSuperview()
        }
        
        tooltipButton.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

// MARK: - Configuration

extension SoptlogMenuCVC {
    func configure(
        title: String,
        value: String,
        hasTooltip: Bool,
        hasChevron: Bool
    ) {
        titleLabel.text = title
        valueLabel.text = value
        tooltipButton.isHidden = !hasTooltip
        chevronImageView.isHidden = !hasChevron
    }
}
