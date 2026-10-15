//
//  SoptlogMenuCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit

import Core
import MDS

final class SoptlogMenuCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var rightStackViewTrailingConstraint: Constraint?
    public private(set) lazy var toolTipButtonTapped = tooltipButton.publisher(for: .touchUpInside)
        .withUnretained(self)
        .map { owner, _ in
            owner.tooltipButton.convert(owner.tooltipButton.bounds, to: nil)
        }.asDriver()
    
    private(set) var cancelBag = CancelBag()
    
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
        label.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
        return label
    }()
    
    private let tooltipButton: UIButton = {
        let button = UIButton()
        button.setImage(MDSIcon.alertCircleOutlined.image, for: .normal)
        button.tintColor = SemanticColor.Fg.Neutral.default
        button.isHidden = true
        return button
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MDSIcon.chevronRightOutlined.image
        imageView.tintColor = SemanticColor.Fg.Neutral.default
        imageView.isHidden = true
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = SemanticColor.Stroke.Neutral.ghost
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
    
    // MARK: - override
    
    override func prepareForReuse() {
        cancelBag.cancel()
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
            rightStackViewTrailingConstraint = make.trailing.equalToSuperview().inset(13).constraint
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
        hasChevron: Bool,
        showSeparator: Bool = true
    ) {
        titleLabel.text = title
        titleLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
        valueLabel.text = value
        valueLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.bold)
        tooltipButton.isHidden = !hasTooltip
        chevronImageView.isHidden = !hasChevron
        separatorView.isHidden = !showSeparator
        
        rightStackViewTrailingConstraint?.update(inset: hasChevron ? 13 : 19)
    }
}
