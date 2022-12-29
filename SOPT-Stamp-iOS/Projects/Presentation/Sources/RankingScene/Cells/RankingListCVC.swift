//
//  RankingListCVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import SnapKit

final class RankingListCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    private var model: RankingModel?
    
    // MARK: - UI Components
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.text = "4"
        label.font = DSKitFontFamily.Montserrat.bold.font(size: 30.adjusted)
        label.textColor = DSKitAsset.Colors.gray500.color
        label.textAlignment = .center
        return label
    }()
    
    private lazy var userSentenceStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.distribution = .fillProportionally
        st.addArrangedSubviews(usernameLabel, sentenceLabel)
        st.spacing = 4
        return st
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "해롱이"
        label.setTypoStyle(.h3)
        label.textColor = DSKitAsset.Colors.gray800.color
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let sentenceLabel: UILabel = {
        let label = UILabel()
        label.text = "한마디 하겠습니다"
        label.setTypoStyle(.caption1)
        label.textColor = DSKitAsset.Colors.gray700.color
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "100점"
        label.setTypoStyle(.number2)
        label.partFontChange(targetString: "점", font: DSKitFontFamily.Pretendard.medium.font(size: 12))
        label.textColor = DSKitAsset.Colors.gray400.color
        return label
    }()
    
    // MARK: - View Life Cycles
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension RankingListCVC {
    
    public func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray50.color
        self.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        self.addSubviews(rankLabel, userSentenceStackView, scoreLabel)
        
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16.adjusted)
            make.width.equalTo(53.adjusted)
        }
        
        userSentenceStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankLabel.snp.trailing).offset(16.adjusted)
            make.width.lessThanOrEqualTo(157.adjusted)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20.adjusted)
        }
    }
}

// MARK: - Methods

extension RankingListCVC {
    
    public func setData(model: RankingModel, rank: Int) {
        self.model = model
        rankLabel.text = String(rank)
        usernameLabel.text = model.username
        sentenceLabel.text = model.sentence
        scoreLabel.text = "\(model.score)점"
        scoreLabel.partFontChange(targetString: "점",
                                  font: DSKitFontFamily.Pretendard.medium.font(size: 12))
    }
}

extension RankingListCVC: RankingListTappble {
    func getModelItem() -> RankingListTapItem? {
        guard let model = model else { return nil }
        return RankingListTapItem.init(username: model.username,
                                       sentence: model.sentence,
                                       userId: model.userId)
    }
}
