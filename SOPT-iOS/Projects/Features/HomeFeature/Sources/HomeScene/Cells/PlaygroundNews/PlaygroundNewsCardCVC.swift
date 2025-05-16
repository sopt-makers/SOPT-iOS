//
//  PlaygroundNewsCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import Core
import DSKit

enum PlaygroundNewsCardCVCStatus {
    case focusing
    case unfocusing
}

final class PlaygroundNewsCardCVC: UICollectionViewCell {
    
    // MARK: - Properties

    private let categorySubPhraseView = HomeCategoryTagView().setTitleColor(DSKitAsset.Colors.orange300.color.withAlphaComponent(0.6))

    private let verticalDividerView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icVerticalDivider.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let categoryTagView = HomeCategoryTagView().setTitleColor(DSKitAsset.Colors.orange300.color.withAlphaComponent(0.6))
    
    private let profileImageView = CustomProfileImageView().hideBorder()
    
    private let userNameLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 10)
    }
    
    private let userPartLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray500.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 10)
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    private let userStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let postTitleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let postContentLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray500.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.numberOfLines = 2
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 6
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setStackView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension PlaygroundNewsCardCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        self.layer.cornerRadius = 12
    }

    private func setLayout() {
        self.addSubviews(userStackView, contentStackView)

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        userStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(userStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(22)
            make.top.equalToSuperview().inset(21)
        }
    }
    
    private func setStackView() {
        categoryStackView.addArrangedSubviews(
            categorySubPhraseView,
            verticalDividerView,
            categoryTagView
        )
        
        userStackView.addArrangedSubviews(
            profileImageView,
            userNameLabel,
            userPartLabel
        )
        
        userStackView.setCustomSpacing(5, after: profileImageView)
        userStackView.setCustomSpacing(1, after: userNameLabel)
        
        contentStackView.addArrangedSubviews(
            categoryStackView,
            postTitleLabel,
            postContentLabel
        )
    }
}

// MARK: - Methods

extension PlaygroundNewsCardCVC {
    func configureCell(model: HomePresentationModel.PlaygroundNews) {
        self.categorySubPhraseView.setData(with: "활동기수의 따끈한 새소식")
        self.categoryTagView.setData(with: model.category)
        self.userNameLabel.text = "김차돌"
        self.userPartLabel.text = "32기 기획"
        if let profileImage = model.profileImage {
            self.profileImageView.setImage(with: profileImage)
        }
        self.postTitleLabel.text = "나 메이커스팀인데 메팀 좋다"
        self.postContentLabel.text = "본문 내용은 두줄로 보여줍니다. 본문 내용은 두줄로 보여줍니다.본문 내용은 두줄로 보여줍니다."
        self.postContentLabel.setLineSpacing(lineSpacing: 1)
    }
}


// MARK: - Animation Methods

extension PlaygroundNewsCardCVC {
    func setOutlinedAnimated() {
        self.layer.borderColor = DSKitAsset.Colors.orange300.color.cgColor
        self.layer.borderWidth = 0
        UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.changeComponentsUI(by: .focusing)
        }) { _ in 
            UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.changeComponentsUI(by: .unfocusing)
            })
        }
    }
    
    private func animateColorFades(_ changes: [(UIView, () -> Void)]) {
        for (view, change) in changes {
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: change, completion: nil)
        }
    }
    
    private func changeComponentsUI(by status: PlaygroundNewsCardCVCStatus) {
        switch status {
        case .focusing:
            self.layer.borderWidth = 1
            self.animateColorFades([
                (self.userNameLabel, { self.userNameLabel.textColor = DSKitAsset.Colors.gray30.color }),
                (self.userPartLabel, { self.userPartLabel.textColor = DSKitAsset.Colors.gray400.color }),
                (self.categorySubPhraseView, { self.categorySubPhraseView.setTitleColor(DSKitAsset.Colors.orange300.color) }),
                (self.categoryTagView, { self.categoryTagView.setTitleColor(DSKitAsset.Colors.orange300.color) }),
                (self.postTitleLabel, { self.postTitleLabel.textColor = DSKitAsset.Colors.white100.color }),
                (self.postContentLabel, { self.postContentLabel.textColor = DSKitAsset.Colors.gray400.color })
            ])
        case .unfocusing:
            self.layer.borderWidth = 0
            self.animateColorFades([
                (self.userNameLabel, { self.userNameLabel.textColor = DSKitAsset.Colors.gray200.color }),
                (self.userPartLabel, { self.userPartLabel.textColor = DSKitAsset.Colors.gray500.color }),
                (self.categorySubPhraseView, { self.categorySubPhraseView.setTitleColor(DSKitAsset.Colors.orange300.color.withAlphaComponent(0.6)) }),
                (self.categoryTagView, { self.categoryTagView.setTitleColor(DSKitAsset.Colors.orange300.color.withAlphaComponent(0.6)) }),
                (self.postTitleLabel, { self.postTitleLabel.textColor = DSKitAsset.Colors.gray200.color }),
                (self.postContentLabel, { self.postContentLabel.textColor = DSKitAsset.Colors.gray500.color })
            ])
        }
    }
}
