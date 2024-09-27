//
//  DailySoptuneCardVC.swift
//  DailySoptuneFeature
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

public final class DailySoptuneCardVC: UIViewController {

	// MARK: - UI Components
	
	private let backButton = UIButton().then {
		$0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray30.color), for: .normal)
	}
	
	private let subCardLabel = UILabel().then {
		$0.textColor = DSKitAsset.Colors.gray300.color
		$0.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
		$0.text = "어려움을 전부 극복할"
	}
	
	private let cardLabel = UILabel().then {
		$0.text = "OO부적이 왔솝"
		$0.textColor = DSKitAsset.Colors.white100.color
		$0.font = DSKitFontFamily.Suit.bold.font(size: 28)
	}
	
	private let cardImage = UIImageView().then {
		$0.image = DSKitAsset.Assets.imgTitlecards.image
	}
	
	private let goToHomeButton = AppOutlinedButton(title: I18N.DailySoptune.goHome)
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		setUI()
		setLayout()
	}
}

// MARK: UI & Layout

private extension DailySoptuneCardVC {
	func setUI() {
		view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
	}
	
	func setLayout() {
		self.view.addSubviews(backButton, subCardLabel, cardLabel, cardImage, goToHomeButton)
		
		backButton.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(2.adjustedH)
			make.leading.equalToSuperview().inset(8.adjusted)
			make.size.equalTo(40)
		}
		
		subCardLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(48.adjustedH)
			make.centerX.equalToSuperview()
			make.height.equalTo(24.adjustedH)
		}
		
		cardLabel.snp.makeConstraints { make in
			make.top.equalTo(subCardLabel.snp.bottom).offset(2.adjustedH)
			make.centerX.equalToSuperview()
			make.height.equalTo(42.adjustedH)
		}
		
		goToHomeButton.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(49.adjustedH)
			make.leading.trailing.equalToSuperview().inset(124.adjusted)
			make.height.equalTo(42.adjustedH)
		}
		
		cardImage.snp.makeConstraints { make in
			make.top.equalTo(cardLabel.snp.bottom).offset(41.adjustedH)
			make.leading.trailing.equalToSuperview().inset(40.adjusted)
			make.bottom.equalTo(goToHomeButton.snp.top).offset(-36.adjustedH)
		}
	}
}
