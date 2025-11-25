//
//  SoptlogBannerCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogBannerCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.gray900.color
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let serviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.imgDailysoptune.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = DSKitAsset.Colors.white.color
        label.font = DSKitFontFamily.Suit.bold.font(size: 18)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = I18N.Soptlog.dailyFortuneButton
        label.textColor = DSKitAsset.Colors.gray200.color
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.chevronRight.image
            .withTintColor(DSKitAsset.Colors.gray200.color)
        return imageView
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
    
    // MARK: - UI & Layout
    
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews(serviceImageView, titleLabel, subtitleLabel, arrowImageView)
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        serviceImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(serviceImageView.snp.trailing).offset(14)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.top.equalTo(subtitleLabel.snp.top)
            make.leading.equalTo(subtitleLabel.snp.trailing)
        }
    }
    
    // MARK: - Configuration
    
    func configure(title: String?) {
        titleLabel.text = title
    }
}
