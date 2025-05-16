//
//  HomeDefaultHeaderView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Lottie

final class HomeDefaultHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 20)
        $0.textColor = DSKitAsset.Colors.white100.color
    }

    private lazy var orangeCharacterLottieView = LottieAnimationView(name: "insightOrangeCharacter",
                                                                     bundle: DSKitResources.bundle).then {
        $0.loopMode = .loop
    }
        
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeDefaultHeaderView {
    private func setLayout() {
        self.clipsToBounds = true
        
        self.addSubviews(titleLabel, orangeCharacterLottieView)
        
        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        orangeCharacterLottieView.snp.makeConstraints { make in
            make.width.equalTo(124)
            make.height.equalTo(95)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }

    /// 인사이트 섹션일 때만 lottie에 의해서 view의 높이가 달라져, 타이틀의 레이아웃을 재설정합니다.
    private func setTitleLabelLayoutForInsight() {
        titleLabel.snp.removeConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Methods

extension HomeDefaultHeaderView {
    func configureView<T: HomeSectionKindProtocol>(sectionKind: T) {
        self.titleLabel.text = sectionKind.title
        self.orangeCharacterLottieView.isHidden = true
        
        if let memberKind = sectionKind as? HomeForMemberSectionLayoutKind {
            let shouldShow = (memberKind == .insight)
            self.orangeCharacterLottieView.isHidden = !shouldShow
            
            if shouldShow {
                self.orangeCharacterLottieView.play()
                setTitleLabelLayoutForInsight()
            } else {
                self.orangeCharacterLottieView.stop()
            }
        }
    }
}
