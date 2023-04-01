//
//  BriefNoticeCVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class BriefNoticeCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.black60.color
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let noticeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.icnNotice.image
        imageView.tintColor = DSKitAsset.Colors.gray60.color
        return imageView
    }()
    
    private let noticeLabel: UILabel = {
       let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray60.color
        label.font = UIFont.Main.body1
        return label
    }()
    
    private let moreNoticeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(DSKitAsset.Assets.btnArrowRight.image, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        return button
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

extension BriefNoticeCVC {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(containerView)
        containerView.addSubviews(noticeIconImageView, noticeLabel, moreNoticeButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        noticeIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.width.equalTo(noticeIconImageView.snp.height)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(noticeIconImageView.snp.trailing).offset(6)
            make.trailing.greaterThanOrEqualToSuperview().inset(32)
        }
        
        moreNoticeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(moreNoticeButton.snp.height)
        }
    }
}

// MARK: - Methods
extension BriefNoticeCVC {
    func initCell(text: String) {
        self.noticeLabel.text = text
    }
}
