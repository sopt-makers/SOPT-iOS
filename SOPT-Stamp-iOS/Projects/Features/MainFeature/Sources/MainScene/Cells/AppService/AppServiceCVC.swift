//
//  AppServiceCVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class AppServiceCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let serviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.headline2
        label.textColor = DSKitAsset.Colors.black100.color
        label.textAlignment = .center
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [serviceImageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
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

extension AppServiceCVC {
    private func setUI() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 15
    }
    
    private func setLayout() {
        self.addSubviews(containerStackView)
        
        serviceImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
                
        containerStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(9)
            make.leading.trailing.equalToSuperview().inset(13)
        }
    }
}

// MARK: - Methods

extension AppServiceCVC {
    func initCell(serviceType: AppServiceType) {
        self.serviceImageView.image = serviceType.image
        self.titleLabel.text = serviceType.title
        self.backgroundColor = serviceType.backgroundColor
    }
}
