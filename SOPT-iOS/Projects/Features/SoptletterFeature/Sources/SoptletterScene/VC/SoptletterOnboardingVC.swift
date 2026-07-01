//
//  SoptletterOnboardingVC.swift
//  SoptletterFeature
//
//  Created by 최주리 on 5/25/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Then

import Core
import DSKit

final class SoptletterOnboardingVC: UIViewController {
    
    private let viewModel: SoptletterOnboardingViewModel
    private let cancelBag = CancelBag()
    
    private lazy var naviBackTap: Driver<Void> = backButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    private lazy var startTap: Driver<Void> = startButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
 
    private let imageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLetterOnboarding.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .bottom
    }
    
    private let titleImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.soptletterTitleKr.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let secondTitleImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.soptletterTitleEn.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let descriptionLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.alignment = .center

            let attributedString = NSAttributedString(
                string: I18N.Soptletter.Onboarding.descriptionText,
                attributes: [
                    .font: DSKitFontFamily.Suit.medium.font(size: 16),
                    .foregroundColor: DSKitAsset.Colors.gray200.color,
                    .kern: -1.5,
                    .paragraphStyle: paragraphStyle
                ]
            )

            $0.attributedText = attributedString
            $0.numberOfLines = 0
    }
    
    private let startButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DSKitAsset.Colors.white.color
        config.background.cornerRadius = 12
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
        attributeContainer.foregroundColor = DSKitAsset.Colors.black.color
        
        config.attributedTitle = AttributedString(I18N.Soptletter.Onboarding.startButtonTitle, attributes: attributeContainer)
        $0.configuration = config
    }
    
    private let backButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray10.color), for: .normal)
    }
    
    init(viewModel: SoptletterOnboardingViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        bindViewModel()
    }
}

extension SoptletterOnboardingVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubviews(imageView, titleStackView, descriptionLabel, startButton, backButton)
        titleStackView.addArrangedSubviews(titleImageView, secondTitleImageView)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(32)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-83)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
}

private extension SoptletterOnboardingVC {
    func bindViewModel() {
        let input = SoptletterOnboardingViewModel.Input(
            naviBackTap: naviBackTap,
            startTap: startTap
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
    }
}
