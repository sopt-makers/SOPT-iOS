//
//  DailySoptuneCardVC.swift
//  DailySoptuneFeature
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit
import Domain

import BaseFeatureDependency

public final class DailySoptuneCardVC: UIViewController, DailySoptuneCardViewControllable {
    
    // MARK: - Properties

    public var viewModel: DailySoptuneCardViewModel
    private let cardModel: DailySoptuneCardModel
    private let cancelBag = CancelBag()

	// MARK: - UI Components
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
	
	private let backButton = UIButton().then {
		$0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray30.color), for: .normal)
	}
	
	private let subCardLabel = UILabel().then {
		$0.textColor = DSKitAsset.Colors.gray300.color
		$0.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
	}
	
	private let cardLabel = UILabel().then {
		$0.textColor = DSKitAsset.Colors.white100.color
		$0.font = DSKitFontFamily.Suit.bold.font(size: 28)
	}
	
	private let cardImage = UIImageView().then {
		$0.image = DSKitAsset.Assets.imgTitlecards.image
	}
	
	private let goToHomeButton = AppOutlinedButton(title: I18N.DailySoptune.goHome)
    
    // MARK: - initialization
    
    init(cardModel: DailySoptuneCardModel, viewModel: DailySoptuneCardViewModel) {
        self.cardModel = cardModel
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
        setData()
        bindViewModels()
	}
}

// MARK: UI & Layout

private extension DailySoptuneCardVC {
    private enum Metric {
        static let cardWidth = 295.adjusted
        static let cardRatio = 450.0 / 295.0
    }
	func setUI() {
		view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        self.navigationController?.isNavigationBarHidden = true
	}
	
	func setLayout() {
        self.view.addSubviews(backButton, scrollView)
        scrollView.addSubviews(subCardLabel, cardLabel, cardImage, goToHomeButton)
		
		backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(2)
            make.leading.equalToSuperview().inset(8)
            make.size.equalTo(40)
		}
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
		
		subCardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
			make.centerX.equalToSuperview()
            make.height.equalTo(24)
		}
		
		cardLabel.snp.makeConstraints { make in
            make.top.equalTo(subCardLabel.snp.bottom).offset(2)
			make.centerX.equalToSuperview()
			make.height.equalTo(42)
		}
		
        cardImage.snp.makeConstraints { make in
            make.top.equalTo(cardLabel.snp.bottom).offset(41.adjustedH)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.cardWidth)
            make.height.equalTo(Metric.cardRatio * Metric.cardWidth)
        }
        
		goToHomeButton.snp.makeConstraints { make in
            make.top.equalTo(cardImage.snp.bottom).offset(36)
            make.bottom.equalToSuperview().inset(49)
            make.centerX.equalToSuperview()
			make.height.equalTo(42)
		}
	}
}

// MARK: - Methods

private extension DailySoptuneCardVC {
    func setData() {
        self.subCardLabel.text = cardModel.description
        self.cardLabel.text = "\(cardModel.name)이 왔솝"
        self.cardLabel.partColorChange(targetString: "\(cardModel.name)", textColor: UIColor(hex: "\(cardModel.imageColorCode)"))
        self.cardImage.setImage(with: cardModel.imageURL)
    }
    
    private func bindViewModels() {
        let input = DailySoptuneCardViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            goToHomeButtonTap: self.goToHomeButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            backButtonTap: self.backButton.publisher(for: .touchUpInside).mapVoid().asDriver()
        )
        
        let _ = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
}
