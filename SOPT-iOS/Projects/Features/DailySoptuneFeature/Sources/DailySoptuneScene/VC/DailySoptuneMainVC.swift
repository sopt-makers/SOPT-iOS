//
//  DailySoptuneMainVC.swift
//  DailySoptuneFeature
//
//  Created by 강윤서 on 9/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

import SnapKit
import Then

import BaseFeatureDependency

public final class DailySoptuneMainVC: UIViewController, DailySoptuneMainViewControllable {

	// MARK: - Properties
	
	public var viewModel: DailySoptuneMainViewModel
	private var cancelBag = CancelBag()
    
    private let viewDidLoaded: Driver<Void> = PassthroughSubject<Void, Never>().asDriver()
    private lazy var todayFortuneButtonTapped: Driver<Void> = checkTodayFortuneButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    private lazy var backButtonTapped: Driver<Void> = backButton.publisher(for: .touchUpInside).mapVoid().asDriver()
	
	// MARK: - UI Components
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
	
	private let backButton = UIButton().then {
		$0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray30.color), for: .normal)
	}
	
	private let dateLabel = UILabel().then {
		$0.textColor = DSKitAsset.Colors.gray100.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
		$0.text = setDateFormat(to: "M월 d일 EEEE")
	}
	
	private let recieveFortune = UILabel().then {
		$0.text = I18N.DailySoptune.recieveTodayFortune
		$0.textColor = DSKitAsset.Colors.gray100.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 18)
	}
	
	private let todayFortuneImage = UIImageView().then {
		$0.image = DSKitAsset.Assets.imgDailysoptune.image
	}
	
	private let titleCardsImage = UIImageView().then {
		$0.image = DSKitAsset.Assets.imgTitlecards.image
	}
	
	private let checkTodayFortuneButton = AppCustomButton(title: I18N.DailySoptune.checkTodayFortune)
		.setFontColor(customFont: DSKitFontFamily.Suit.semiBold.font(size: 18))
	
	// MARK: - Initialization
	
	public init(viewModel: DailySoptuneMainViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View Life Cycle
	
	public override func viewDidLoad() {
        super.viewDidLoad()
		
		setUI()
		setLayout()
        bindViewModels()
    }
}

// MARK: UI & Layout

private extension DailySoptuneMainVC {
    private enum Metric {
        static let soptuneLogoWidth = 269.adjusted
        static let soptuneLogoRatio = 208.0 / 269.0
        
        static let cardWidth = 307.adjusted
        static let cardRatio = 270.0 / 307.0
    }
    
	func setUI() {
		view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        navigationController?.navigationBar.isHidden = true
	}
	
	func setLayout() {
        self.view.addSubviews(scrollView, backButton, checkTodayFortuneButton)
        scrollView.addSubviews(dateLabel, recieveFortune, todayFortuneImage, titleCardsImage)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
            make.leading.trailing.equalToSuperview()
        }
        
		backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(2)
            make.leading.equalToSuperview().inset(8)
            make.size.equalTo(40)
		}
		
		dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
			make.centerX.equalToSuperview()
		}
		
		recieveFortune.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(2)
			make.centerX.equalToSuperview()
		}
		
		todayFortuneImage.snp.makeConstraints { make in
			make.top.equalTo(recieveFortune.snp.bottom).offset(9.adjustedH)
            make.centerX.equalToSuperview()
            make.height.equalTo(Metric.soptuneLogoRatio * Metric.soptuneLogoWidth)
            make.width.equalTo(Metric.soptuneLogoWidth)
		}
		
		checkTodayFortuneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(49)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
		}
		
		titleCardsImage.snp.makeConstraints { make in
            make.top.equalTo(todayFortuneImage.snp.bottom).offset(14.adjustedH)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.cardWidth)
            make.height.equalTo(Metric.cardRatio * Metric.cardWidth)
            make.bottom.equalToSuperview().inset(20)
		}
	}
    
    func bindViewModels() {
        let input = DailySoptuneMainViewModel
            .Input(
                viewDidLoad: viewDidLoaded.asDriver(),
                naviBackButtonTap: backButtonTapped,
                receiveTodayFortuneButtonTap: todayFortuneButtonTapped
            )
        
        let _ = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
}
