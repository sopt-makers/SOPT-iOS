//
//  DailySoptuneResultVC.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency
import DailySoptuneFeatureInterface

public final class DailySoptuneResultVC: UIViewController, DailySoptuneResultViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: DailySoptuneResultViewModel
    private var cancelBag = CancelBag()
    private let resultModel: DailySoptuneResultModel
    
    private lazy var receiveTodaysFortuneButtonTap: Driver<Void> = receiveTodaysFortuneCardButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    
    // MARK: - UI Components
    
    private let backButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray30.color), for: .normal)
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    // 오늘의 솝마디 부분
    
    private lazy var dailySoptuneResultContentView = DailySoptuneResultContentView()
    
    // 콕 찌르기 부분
    
    private let dailySoptuneResultPokeView = DailySoptuneResultPokeView()
    
    // 오늘의 부적 받기 버튼
    
    private lazy var receiveTodaysFortuneCardButton = AppCustomButton(title: I18N.DailySoptune.receiveTodaysFortuneCard)
        .setFontColor(customFont: DSKitFontFamily.Suit.semiBold.font(size: 18))
        .setEnabled(true)
    
    // MARK: - Initialization
    
    public init(viewModel: DailySoptuneResultViewModel, resultModel: DailySoptuneResultModel) {
        self.viewModel = viewModel
        self.resultModel = resultModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setStackView()
        self.setLayout()
        self.bindViewModels()
    }
}

// MARK: - UI & Layout

extension DailySoptuneResultVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        self.navigationController?.isNavigationBarHidden = true
        dailySoptuneResultContentView.setData(model: resultModel)
    }
    
    private func setStackView() {
        self.contentStackView.addArrangedSubviews(
                dailySoptuneResultContentView,
                dailySoptuneResultPokeView
        )
    }
    
    private func setLayout() {
        self.view.addSubviews(backButton, scrollView, receiveTodaysFortuneCardButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(2.adjustedH)
            make.leading.equalToSuperview().inset(8.adjusted)
            make.size.equalTo(40.adjusted)
        }
        
        setScrollViewLayout()
        
        receiveTodaysFortuneCardButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
            make.width.equalTo(335)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    private func setScrollViewLayout() {
        self.scrollView.addSubviews(contentStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(17.adjustedH)
            make.width.equalTo((self.view.frame.size.width - 20 * 2).adjusted)
            make.bottom.equalToSuperview().inset(20.adjustedH)
        }
        
    }
}

// MARK: - Methods

private extension DailySoptuneResultVC {
    func bindViewModels() {
        let input = DailySoptuneResultViewModel
            .Input(
                viewDidLoad: Just<Void>(()).asDriver(),
                naviBackButtonTap: self.backButton
                    .publisher(for: .touchUpInside)
                    .mapVoid().asDriver(),
                receiveTodaysFortuneCardTap: receiveTodaysFortuneButtonTap, 
                kokButtonTap: dailySoptuneResultPokeView.kokButtonTap,
                profileImageTap: dailySoptuneResultPokeView.profileTap
            )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.randomUser
            .withUnretained(self)
            .sink { owner, model in
                owner.dailySoptuneResultPokeView.setData(with: model.userInfoList[0])
            }.store(in: self.cancelBag)
        
        output.pokeResponse
            .withUnretained(self)
            .sink { owner, updatedUser in
                owner.dailySoptuneResultPokeView.changeUIAfterPoke(newUserModel: updatedUser)
            }.store(in: cancelBag)
    }
}

