//
//  SoptlogAppServiceCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogAppServiceCVC: UICollectionViewCell {
    
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
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stackView.removeAllSubViews()
    }
}

// MARK: - UI & Layout

extension SoptlogAppServiceCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        stackView.addArrangedSubviews(serviceLabel, serviceImageView, serviceValue)
        
        serviceImageView.snp.makeConstraints { make in
            make.size.equalTo(39)
        }
        
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension SoptlogAppServiceCVC {
    func configureCell(model: SoptlogPresentationModel.AppService?) {
        guard let model else { return }
        self.serviceLabel.text = model.serviceName
        self.serviceValue.text = model.serviceValue
        self.serviceImageView.setImage(with: model.serviceImageURL)
    }
}
