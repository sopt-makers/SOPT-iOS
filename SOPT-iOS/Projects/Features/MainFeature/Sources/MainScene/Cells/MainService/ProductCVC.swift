//
//  ProductCVC.swift
//  MainFeature
//
//  Created by sejin on 2023/09/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class ProductCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let serviceIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.icnAttendance.image
        imageView.tintColor = DSKitAsset.Colors.white.color
        return imageView
    }()
    
    private let serviceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Main.headline2
        label.textColor = DSKitAsset.Colors.white100.color
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let serviceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Main.caption1
        label.textColor = DSKitAsset.Colors.gray30.color
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [serviceTitleLabel, serviceDescriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [serviceIcon, labelStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
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

extension ProductCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.black60.color
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

extension ProductCVC {
    func initCell(serviceType: ServiceType, userType: UserType) {
        serviceIcon.image = serviceType.icon
        serviceTitleLabel.text = serviceType.title
        setDescription(description: serviceType.description(for: userType))
    }
    
    private func setDescription(description: String?) {
        if let description = description {
            serviceDescriptionLabel.isHidden = false
            serviceDescriptionLabel.text = description
        } else {
            serviceDescriptionLabel.isHidden = true
        }
    }
}

