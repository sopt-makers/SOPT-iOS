//
//  SoptletterCheckNicknameVC.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/21/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core
import Combine

final class SoptletterCheckNicknameVC: UIViewController {
    
    private let viewModel: SoptletterNicknameCheckViewModel
    private let cancelBag = CancelBag()
    
    private lazy var naviBackTap: Driver<Void> = backButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    private lazy var goTap: Driver<Void> = button
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    // TODO: - 추후 기수 연결
    private let number: Int = 38
    
    private let cardView = NicknameCheckCardView()
    
    private lazy var button = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DSKitAsset.Colors.white.color
        config.background.cornerRadius = 12
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
        attributeContainer.foregroundColor = DSKitAsset.Colors.black.color
        
        config.attributedTitle = AttributedString("\(number)" + I18N.Soptletter.Onboarding.goButtonTitle, attributes: attributeContainer)
        $0.configuration = config
    }
    
    private let backButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray10.color), for: .normal)
    }
    
    init(viewModel: SoptletterNicknameCheckViewModel) {
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

extension SoptletterCheckNicknameVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubviews(backButton, cardView, button)
        
        backButton.snp.makeConstraints {
              $0.top.equalTo(safeArea.snp.top).offset(12)
              $0.leading.equalToSuperview().inset(20)
              $0.size.equalTo(32)
          }
          cardView.snp.makeConstraints {
              $0.top.equalTo(backButton.snp.bottom).offset(32)
              $0.leading.trailing.equalToSuperview().inset(20)
              $0.bottom.lessThanOrEqualTo(button.snp.top).offset(-20)
          }
          button.snp.makeConstraints {
              $0.bottom.equalTo(view.snp.bottom).offset(-83)
              $0.leading.trailing.equalToSuperview().inset(20)
              $0.height.equalTo(56)
          }
    }
}

private extension SoptletterCheckNicknameVC {
    func bindViewModel() {
        let input = SoptletterNicknameCheckViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            naviBackTap: naviBackTap,
            goTap: goTap
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.profileSubject
            .withUnretained(self)
            .sink { owner, profile in
                owner.cardView.configure(nickName: profile.nickname, number: owner.number)
            }.store(in: cancelBag)
    }
}
