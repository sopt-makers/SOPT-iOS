//
//  MainServiceCVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class MainServiceCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let serviceIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = DSKitAsset.Colors.orange100.color
        return imageView
    }()
    
    private let serviceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Main.headline1
        label.textColor = DSKitAsset.Colors.white100.color
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let serviceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Main.body1
        label.textColor = DSKitAsset.Colors.gray30.color
        label.textAlignment = .left
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [serviceIcon, serviceTitleLabel, serviceDescriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension MainServiceCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        self.layer.cornerRadius = 15
    }
    
    private func setLayout() {
        self.addSubviews(containerStackView)
        
        serviceIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Methods

extension MainServiceCVC {
    func initCell(serviceType: ServiceType, userType: UserType) {
        serviceIcon.image = serviceType.icon.withRenderingMode(.alwaysTemplate)
        serviceTitleLabel.text = serviceType.mainTitle
        setDescription(description: serviceType.description(for: userType))
    }
    
    private func setDescription(description: String?) {
        if let description = description {
            serviceDescriptionLabel.isHidden = false
            serviceDescriptionLabel.text = description
            containerStackView.setCustomSpacing(4, after: serviceTitleLabel)
        } else {
            serviceDescriptionLabel.isHidden = true
            containerStackView.setCustomSpacing(0, after: serviceTitleLabel)
        }
    }
}
