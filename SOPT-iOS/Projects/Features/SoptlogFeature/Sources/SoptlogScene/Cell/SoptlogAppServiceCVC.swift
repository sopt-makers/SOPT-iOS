//
//  SoptlogAppServiceCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

final class SoptlogAppServiceCVC: UICollectionViewCell {
    
    // MARK: - Properties

    lazy var toolTipButtonTapped = infoToolTipButton.publisher(for: .touchUpInside)
        .withUnretained(self)
        .map { owner, _ in
            owner.infoToolTipButton.convert(owner.infoToolTipButton.bounds, to: nil)
        }.asDriver()
    
    // MARK: - UI Components
    
    private let stackView = UIStackView(frame: .zero).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .center
    }
    
    private let serviceLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
    }
    
    private let serviceImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icHot.image
    }
    
    private let serviceValue = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
    }
    
    private let serviceTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 1
    }
    
    private let infoToolTipButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icInfo.image, for: .normal)
        $0.isHidden = true
    }
    
    // MARK: - init
    
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

extension SoptlogAppServiceCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        setStackView()
        contentView.addSubviews(stackView)
        
        serviceImageView.snp.makeConstraints { make in
            make.size.equalTo(39)
        }
        
        infoToolTipButton.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setStackView() {
        serviceTitleStackView.addArrangedSubviews(serviceLabel, infoToolTipButton)
        stackView.addArrangedSubviews(serviceTitleStackView, serviceImageView, serviceValue)
    }
}

// MARK: - Methods

extension SoptlogAppServiceCVC {
    func configureCell(model: SoptlogPresentationModel.AppService?) {
        guard let model else { return }
        self.serviceLabel.text = model.serviceName
        self.serviceValue.text = model.serviceValue
        self.serviceImageView.setImage(with: model.serviceImageURL)
        self.infoToolTipButton.isHidden = model.serviceName != "솝레벨"
    }
}
