//
//  SoptletterCheckNicknameVC.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/21/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import MDS
import Core
import Combine

final class SoptletterCheckNicknameVC: UIViewController {

    private let viewModel: SoptletterNicknameCheckViewModel
    private let cancelBag = CancelBag()

    private lazy var naviBackTap: Driver<Void> = naviBar.leftButtonTapped

    private lazy var goTap: Driver<Void> = goButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    private let cardView = NicknameCheckCardView()

    private let cardCenteringGuide = UILayoutGuide()

    private lazy var goButton = MDSActionButton(
        variant: .primary,
        size: .large,
        title: I18N.Soptletter.Onboarding.goButtonTitle
    )

    // TODO: - MDS 전용 네비게이터가 추가되면 교체
    private lazy var naviBar = OPNavigationBar(
        self,
        type: .oneLeftButton,
        backgroundColor: SemanticColor.Bg.Layer.basement,
        ignoreLeftButtonAction: true
    ).then {
        $0.setLeftButtonImage(MDSIcon.xCloseOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold))
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
        view.backgroundColor = SemanticColor.Bg.Layer.basement
    }

    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide

        view.addSubviews(naviBar, cardView, goButton)
        view.addLayoutGuide(cardCenteringGuide)

        naviBar.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        goButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
        }

        cardCenteringGuide.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.bottom.equalTo(goButton.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        cardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
            $0.top.greaterThanOrEqualTo(naviBar.snp.bottom).offset(BaseSpacing.Base.s24)
            $0.centerY.equalTo(cardCenteringGuide)
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
            .receive(on: DispatchQueue.main)
            .sink { owner, profile in
                owner.cardView.configure(nickName: profile.nickname, number: profile.currentGeneration)
                owner.goButton.title = "\(profile.currentGeneration)" + I18N.Soptletter.Onboarding.goButtonTitle
            }.store(in: cancelBag)
    }
}
