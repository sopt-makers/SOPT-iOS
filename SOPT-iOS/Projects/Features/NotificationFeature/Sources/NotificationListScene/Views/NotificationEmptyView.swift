//
//  NotificationEmptyView.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core
import DSKit

final class NotificationEmptyView: UIView {
    
    // MARK: - UI Components
    
    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.imgNotificationNon.image.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = I18N.Notification.emptyNotification
        label.font = .Attendance.h1
        label.textColor = DSKitAsset.Colors.gray80.color
        label.textAlignment = .center
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [notificationImageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
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
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(containerStackView)
        
        notificationImageView.snp.makeConstraints { make in
            make.width.height.equalTo(124)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
