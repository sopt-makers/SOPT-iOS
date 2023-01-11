//
//  SpeechBallonView.swift
//  DSKit
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

import SnapKit

public class SpeechBalloonView: UIView {
    
    // MARK: - Properties
    
    var viewLevel = RectangleViewRank.rankOne
    
    // MARK: - UI Components
    
    private let balloonTailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = DSKitAsset.Assets.balloonTail.image.withRenderingMode(.alwaysTemplate)
        return iv
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var sentenceLabelStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.distribution = .equalCentering
        st.alignment = .center
        st.spacing = 0
        st.addArrangedSubviews(sentenceLabel, leftArrowImage)
        return st
    }()
    
    private let sentenceLabel: UILabel = {
        let label = UILabel()
        label.setTypoStyle(.subtitle3)
        label.textColor = DSKitAsset.Colors.black.color
        label.textAlignment = .center
        label.clipsToBounds = true
        label.sizeToFit()
        label.setCharacterSpacing(0)
        return label
    }()
    
    private let leftArrowImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = DSKitAsset.Assets.icLeftArrow.image.withRenderingMode(.alwaysTemplate)
        return iv
    }()
    
    // MARK: View Life Cycle
    
    public init(level: RectangleViewRank, sentence: String) {
        self.init()
        
        self.viewLevel = level
        sentenceLabel.text = sentence
        setUI()
        setLayout(sentence: sentence)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension SpeechBalloonView {
    
    private func setUI() {
        switch viewLevel {
        case .rankOne:
            backgroundView.backgroundColor = DSKitAsset.Colors.purple300.color
            sentenceLabel.textColor = DSKitAsset.Colors.white.color
            leftArrowImage.tintColor = .white
            balloonTailImageView.tintColor = DSKitAsset.Colors.purple300.color
        case .rankTwo:
            backgroundView.backgroundColor = DSKitAsset.Colors.pink300.color
            sentenceLabel.textColor = DSKitAsset.Colors.white.color
            leftArrowImage.tintColor = .white
            balloonTailImageView.tintColor = DSKitAsset.Colors.pink300.color
        case .rankThree:
            backgroundView.backgroundColor = DSKitAsset.Colors.mint300.color
            sentenceLabel.textColor = DSKitAsset.Colors.black.color
            leftArrowImage.tintColor = .black
            balloonTailImageView.tintColor = DSKitAsset.Colors.mint300.color
        }
        
        guard self.sentenceLabel.text == I18N.RankingList.noSentenceText else { return }
        self.sentenceLabel.textColor = DSKitAsset.Colors.gray500.color
        self.backgroundView.backgroundColor = DSKitAsset.Colors.gray100.color
        self.leftArrowImage.tintColor = DSKitAsset.Colors.gray500.color
        self.balloonTailImageView.tintColor = DSKitAsset.Colors.gray100.color
    }
    
    private func setLayout(sentence: String) {
        self.addSubviews(backgroundView, balloonTailImageView)
        
        self.backgroundView.addSubview(sentenceLabelStackView)
        
        backgroundView.snp.makeConstraints { make in
            make.height.equalTo(37.adjustedH)
            make.leading.trailing.equalToSuperview()
        }
        
        sentenceLabelStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualTo(273.adjusted)
        }
        
        sentenceLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(241.adjusted)
        }
        
        leftArrowImage.snp.makeConstraints { make in
            make.size.equalTo(32.adjusted)
        }
        
        balloonTailImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(-3).priority(.high)
            make.height.equalTo(11.5)
            make.width.equalTo(10)
            switch viewLevel {
            case .rankOne:
                make.centerX.equalTo(backgroundView)
            case .rankTwo:
                make.centerX.equalTo(backgroundView.snp.leading).offset(45.adjusted)
            case .rankThree:
                make.centerX.equalTo(backgroundView.snp.trailing).offset(-45.adjusted)
            }
            make.bottom.equalToSuperview()
        }
    }
}
