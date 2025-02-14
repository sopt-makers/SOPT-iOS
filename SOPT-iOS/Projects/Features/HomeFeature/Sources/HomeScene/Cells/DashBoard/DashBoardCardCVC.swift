//
//  DashBoardCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class DashBoardCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
        
    private var descriptionLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 18)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    private let userHistoryView = UserHistoryView()
    
    private let rightArrowWithCircleImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnRightArrowWithCircle.image
    }
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.descriptionLabel.text = nil
    }
}

// MARK: - UI & Layout

extension DashBoardCardCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        self.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        self.addSubviews(
            descriptionLabel,
            userHistoryView,
            rightArrowWithCircleImageView
        )

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(16)
        }
        
        userHistoryView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(250)
            make.height.equalTo(23)
        }
        
        rightArrowWithCircleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
    }
}

// MARK: - Methods

extension DashBoardCardCVC {
    func configureCell(userType: UserType, model: HomePresentationModel.DashBoard? = nil) {
        switch userType {
        case .visitor:
            self.descriptionLabel.font = DSKitFontFamily.Suit.medium.font(size: 18)
            self.descriptionLabel.text = I18N.Home.DashBoard.UserHistory.encourage
            self.descriptionLabel.setLineSpacing(lineSpacing: 5)
            self.rightArrowWithCircleImageView.isHidden = true
        case .active, .inactive:
            guard let model else { return }
            self.descriptionLabel.htmlToString(targetString: model.description,
                                               defaultFont: DSKitFontFamily.Suit.medium.font(size: 18),
                                               boldFont: DSKitFontFamily.Suit.bold.font(size: 18),
                                               defaultColor: DSKitAsset.Colors.white100.color)
            self.descriptionLabel.setLineSpacingWithChaining(lineSpacing: 5)
            self.rightArrowWithCircleImageView.isHidden = false
            guard let historyList = model.historyList else { return }
            userHistoryView.setData(userType: userType, recentHistory: 35, allHistory: historyList)
        }
    }
}
