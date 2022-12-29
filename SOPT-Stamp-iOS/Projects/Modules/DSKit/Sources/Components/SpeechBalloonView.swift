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
    
    private let baloonTailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = DSKitAsset.Assets.balloonTail.image.withRenderingMode(.alwaysTemplate)
        return iv
    }()
    
    private let sentenceLabel: BalloonPaddingLabel = {
        let label = BalloonPaddingLabel()
        label.setTypoStyle(.subtitle3)
        label.textColor = DSKitAsset.Colors.black.color
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.sizeToFit()
        return label
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
            sentenceLabel.backgroundColor = DSKitAsset.Colors.purple300.color
            baloonTailImageView.tintColor = DSKitAsset.Colors.purple300.color
        case .rankTwo:
            sentenceLabel.backgroundColor = DSKitAsset.Colors.pink300.color
            baloonTailImageView.tintColor = DSKitAsset.Colors.pink300.color
        case .rankThree:
            sentenceLabel.backgroundColor = DSKitAsset.Colors.mint300.color
            baloonTailImageView.tintColor = DSKitAsset.Colors.mint300.color
        }
    }
    
    private func setLayout(sentence: String) {
        self.addSubviews(sentenceLabel, baloonTailImageView)
        
        sentenceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            
            let standardSize = calculateLabelSize(sentence: sentence)
            let smallBalloonMinimumWidth: CGFloat = 108
            let smallBalloonCompensates: CGFloat = 10
            let smallBalloonWidth = smallBalloonMinimumWidth - smallBalloonCompensates
            let largeBalloonCompensates: CGFloat = 30 * standardSize / 266.adjusted
            
            if standardSize < smallBalloonWidth.adjusted {
                make.width.equalTo(smallBalloonWidth.adjusted + smallBalloonCompensates)
            } else if standardSize < 266.adjusted {
                make.width.equalTo(standardSize + largeBalloonCompensates)
            } else {
                make.width.lessThanOrEqualToSuperview()
                sentenceLabel.lineBreakMode = .byTruncatingTail
            }
            
            switch viewLevel {
            case .rankOne:
                make.centerX.equalToSuperview()
            case .rankTwo:
                make.leading.equalToSuperview()
            case .rankThree:
                make.trailing.equalToSuperview()
            }
        }
        
        baloonTailImageView.snp.makeConstraints { make in
            make.top.equalTo(sentenceLabel.snp.bottom).offset(-3).priority(.high)
            make.height.equalTo(11.5)
            make.width.equalTo(10)
            switch viewLevel {
            case .rankOne:
                make.centerX.equalTo(sentenceLabel)
            case .rankTwo:
                make.centerX.equalTo(sentenceLabel.snp.leading).offset(45.adjusted)
            case .rankThree:
                make.centerX.equalTo(sentenceLabel.snp.trailing).offset(-45.adjusted)
            }
            make.bottom.equalToSuperview()
        }
    }
    
    private func calculateLabelSize(sentence: String) -> CGFloat {
        let tempLabel = BalloonPaddingLabel()
        tempLabel.text = sentence
        tempLabel.setTypoStyle(.subtitle3)
        tempLabel.sizeToFit()
        return tempLabel.intrinsicContentSize.width
    }
}

@IBDesignable class BalloonPaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 7.0
    @IBInspectable var bottomInset: CGFloat = 7.0
    @IBInspectable var leftInset: CGFloat = 32.0
    @IBInspectable var rightInset: CGFloat = 32.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
