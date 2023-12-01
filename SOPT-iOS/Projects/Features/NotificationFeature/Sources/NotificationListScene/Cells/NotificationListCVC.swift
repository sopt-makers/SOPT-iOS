//
//  NotificationListCVC.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class NotificationListCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body1
        label.textColor = DSKitAsset.Colors.gray100.color
        label.textAlignment = .left
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.caption1
        label.textColor = DSKitAsset.Colors.gray100.color
        label.textAlignment = .right
        return label
    }()
    
    private lazy var titleContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.timeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body1
        label.textColor = DSKitAsset.Colors.gray100.color
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var contentsContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleContainerStackView, self.descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
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

extension NotificationListCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.addSubviews(contentsContainerStackView)
        
        contentsContainerStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        timeLabel.snp.contentCompressionResistanceHorizontalPriority = .greatestFiniteMagnitude
    }
}

// MARK: - Methods

extension NotificationListCVC {
    func initCell(title: String, time: String, description: String?, isRead: Bool) {
        self.titleLabel.text = title
        self.timeLabel.text = time
        self.descriptionLabel.text = description
        self.backgroundColor = isRead ? DSKitAsset.Colors.gray950.color : DSKitAsset.Colors.gray800.color
    }
}
