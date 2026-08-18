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
import MDS

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
    
    // MARK: - UI Properties
 
    private let imageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLetterOnboarding.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = BaseSpacing.Base.s10
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
        $0.numberOfLines = 0
        $0.text = I18N.Soptletter.Onboarding.descriptionText
        $0.setTypography(Typography.body1,
                         textColor: SemanticColor.Fg.Neutral.subtle)
        $0.textAlignment = .center
    }

    private let startButton = MDSActionButton(
        variant: .primary,
        size: .large,
        title: I18N.Soptletter.Onboarding.startButtonTitle
    )

    private let backButton = UIButton().then {
        $0.setImage(MDSIcon.xCloseOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
    }
    
    // MARK: - Init
    
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
        view.backgroundColor = SemanticColor.Bg.Layer.basement
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubviews(imageView, titleStackView, descriptionLabel, startButton, backButton)
        titleStackView.addArrangedSubviews(titleImageView, secondTitleImageView)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(BaseSpacing.Base.s12)
            $0.leading.equalToSuperview().inset(BaseSpacing.Base.s20)
            $0.size.equalTo(BaseSpacing.Base.s24)
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
        }

        titleStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(BaseSpacing.Base.s40)
            $0.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(BaseSpacing.Base.s16)
            $0.centerX.equalToSuperview()
        }

        startButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
        }
    }
}

private extension SoptletterOnboardingVC {
    func bindViewModel() {
        let input = SoptletterOnboardingViewModel.Input(
            naviBackTap: naviBackTap,
            startTap: startTap
        )
        
        _ = viewModel.transform(from: input, cancelBag: cancelBag)
    }
}
