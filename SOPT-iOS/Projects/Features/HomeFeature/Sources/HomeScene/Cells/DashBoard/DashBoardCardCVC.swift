//
//  DashBoardCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class DashBoardCardCVC: UICollectionViewCell {
    
    private(set) lazy var profileEditTap = profileEditView.gesture()
    private(set) var cancelBag = CancelBag()
    
    // MARK: - UI Components
        
    private var descriptionLabel = UILabel().then {
        $0.setTypography(Typography.heading4, textColor: SemanticColor.Fg.Neutral.bold, alignment: .left)
        $0.numberOfLines = 2
    }
    
    private let userHistoryView = UserHistoryView()
    private let profileEditView = DashBoardProfileImageView()
    
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
        self.backgroundColor = SemanticColor.Bg.Neutral.ghost
        self.layer.cornerRadius = BaseRadius.Base.r8
    }
    
    private func setLayout() {
        self.addSubviews(
            descriptionLabel,
            userHistoryView,
            profileEditView
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

        profileEditView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(54)
        }
    }
}

// MARK: - Methods

extension DashBoardCardCVC {
    func configureCell(userType: UserType, model: HomePresentationModel.DashBoard? = nil) {
        switch userType {
        case .visitor:
            self.descriptionLabel.text = I18N.Home.DashBoard.UserHistory.encourage
            self.descriptionLabel.setTypography(Typography.heading4, textColor: SemanticColor.Fg.Neutral.bold, alignment: .left)
            self.profileEditView.isHidden = true
            
            userHistoryView.setData(recentHistory: nil, allHistory: nil)
        case .active, .inactive:
            guard let model else { return }
            self.descriptionLabel.attributedText = model.description
            self.profileEditView.isHidden = false
            self.profileEditView.configure(profileImageURL: model.profileImageURL)
            guard let history = model.history else { return }
            userHistoryView.setData(recentHistory: history.first, allHistory: history)
        }
    }
}
