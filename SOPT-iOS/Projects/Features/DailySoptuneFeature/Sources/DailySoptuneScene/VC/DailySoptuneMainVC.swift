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
	
	// MARK: - UI Components
	
	private let backButton = UIButton().then {
		$0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray30.color), for: .normal)
	}
	
	private let dateLabel = UILabel().then {
		$0.textColor = DSKitAsset.Colors.gray100.color
		$0.font = DSKitFontFamily.Suit.medium.font(size: 16)
		$0.text = "9월 17일 화요일"
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
    }
}

// MARK: UI & Layout

private extension DailySoptuneMainVC {
	func setUI() {
		view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
	}
	
	func setLayout() {
		self.view.addSubviews(backButton, dateLabel, recieveFortune, todayFortuneImage, titleCardsImage, checkTodayFortuneButton)
		
		backButton.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(2.adjustedH)
			make.leading.equalToSuperview().inset(8.adjusted)
			make.size.equalTo(40)
		}
		
		dateLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(40.adjustedH)
			make.centerX.equalToSuperview()
		}
		
		recieveFortune.snp.makeConstraints { make in
			make.top.equalTo(dateLabel.snp.bottom).offset(2.adjustedH)
			make.centerX.equalToSuperview()
		}
		
		todayFortuneImage.snp.makeConstraints { make in
			make.top.equalTo(recieveFortune.snp.bottom).offset(9.adjustedH)
			make.leading.trailing.equalToSuperview().inset(53.adjusted)
			make.height.equalTo(208.adjustedH)
		}
		
		checkTodayFortuneButton.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(49.adjustedH)
			make.leading.trailing.equalToSuperview().inset(20.adjusted)
			make.height.equalTo(56.adjustedH)
		}
		
		titleCardsImage.snp.makeConstraints { make in
			make.bottom.equalTo(checkTodayFortuneButton.snp.top).offset(-32.adjustedH)
			make.leading.trailing.equalToSuperview().inset(34.adjusted)
			make.height.equalTo(270.adjustedH)
		}
	}
}
