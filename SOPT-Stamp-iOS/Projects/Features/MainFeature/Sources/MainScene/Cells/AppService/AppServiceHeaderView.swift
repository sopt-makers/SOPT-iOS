//
//  AppServiceHeaderView.swift
//  MainFeature
//
//  Created by sejin on 2023/04/02.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class AppServiceHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.headline1
        label.textColor = DSKitAsset.Colors.white100.color
        label.textAlignment = .left
        label.text = I18N.Main.appServiceIntroduction
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.caption1
        label.textColor = DSKitAsset.Colors.gray80.color
        label.textAlignment = .left
        label.text = I18N.Main.recommendSopt
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
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

// MARK: - UI & Layout

extension AppServiceHeaderView {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}

// MARK: - Methods

extension AppServiceHeaderView {
    func initCell(userType: UserType) {
        descriptionLabel.isHidden = userType != .visitor
    }
}
