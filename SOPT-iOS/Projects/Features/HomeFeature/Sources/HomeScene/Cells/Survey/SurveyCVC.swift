//
//  SurveyCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 5/31/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import Core
import DSKit

final class SurveyCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private(set) lazy var surveyButtonTap = surveyButton.publisher(for: .touchUpInside)
    private(set) var cancelBag = CancelBag()
    
    private let surveyImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgGirlSurvey.image
    }
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 20)
        $0.textColor = DSKitAsset.Colors.white.color
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.white.color
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private lazy var surveyButton = AppCustomButton()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cancelBag.cancel()
        self.cancelBag = CancelBag()
    }
}

// MARK: - UI & Layout

extension SurveyCVC {
    private func setLayout() {
        self.addSubviews(surveyImageView, titleLabel, subTitleLabel, surveyButton)
        
        surveyImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(surveyImageView.snp.width).multipliedBy(0.41)
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(surveyImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        surveyButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(18)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(182)
        }
    }
    
    private func updateSubTitleLayout() {
        subTitleLabel.snp.updateConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(56)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension SurveyCVC {
    func configureCell(model: HomePresentationModel.Survey) {
        self.titleLabel.text = model.title
        configureSubTitleLabel(with: model.subTitle)
        self.surveyButton.setTitle(model.actionButtonName)
            .setConfigForState(
                bgColor: DSKitAsset.Colors.orange400.color,
                enabledTextColor: DSKitAsset.Colors.gray950.color,
                enabledFont: DSKitFontFamily.Suit.semiBold.font(size: 14)
            )
            .changeInset(top: 12, leading: 20, bottom: 12, trailing: 20)
    }
    
    func configureSubTitleLabel(with text: String) {
        self.subTitleLabel.text = text
        // 피그마 기준, 20자를 넘으면 긴 문장으로 판단해서 두 줄로 보여줍니다.
        if text.count > 20 {
            updateSubTitleLayout()
            subTitleLabel.setLineSpacing(lineSpacing: 3)
            subTitleLabel.textAlignment = .center
        }
    }
}
