//
//  SoptletterPrintVC.swift
//  SoptletterFeature
//
//  Created by dev on 7/11/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit

import BaseFeatureDependency
import Core
import DSKit
import Domain

public final class SoptletterPrintVC: UIViewController {
    
    // MARK: - UI Properties
    
    private let navigationView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray950.color
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.chevronLeft.image, for: .normal)
    }
    
    private lazy var naviBackButtonTap: Driver<Void> = closeButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.textAlignment = .left
        $0.font = DSKitFontFamily.Pretendard.bold.font(size: 18)
        $0.text = "솝레터 출력"
    }
    
    private let cardContainerView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DSKitAsset.Colors.gray200.color.cgColor
        $0.clipsToBounds = true
    }
    
    private let cardTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .white
    }
    
    private let previewImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    private let subtextLabel = UILabel().then {
        $0.text = "미리보기에서는 최대 16개까지 확인할 수 있어요."
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.textAlignment = .center
    }

    private let saveButton = UIButton().then {
        $0.setTitle("PDF 저장하기", for: .normal)
        $0.setTitleColor(DSKitAsset.Colors.gray10.color, for: .normal)
        $0.titleLabel?.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
        $0.backgroundColor = DSKitAsset.Colors.gray600.color
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    // MARK: - Properties
    
    private let viewModel: SoptletterPrintViewModel
    private let previewImage: UIImage
    private let cardTitle: String
    private let cancelBag = CancelBag()
    
    private lazy var saveButtonTap: Driver<Void> = saveButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    // MARK: - LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setPreview(image: previewImage, title: cardTitle)
        bindViewModels()
    }
    
    // MARK: - Initilizer
    
    public init(viewModel: SoptletterPrintViewModel, uiImage: UIImage, title: String = "nn기 솝레터") {
        self.viewModel = viewModel
        self.previewImage = uiImage
        self.cardTitle = title        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func bindViewModels() {
        let input = SoptletterPrintViewModel.Input(
            pdfSaveButtonTap: saveButtonTap,
            naviBackButtonTap: naviBackButtonTap.asDriver()
        )
        
        let _ = self.viewModel.transform(from: input, cancelBag: cancelBag)
    }
    
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.gray950.color
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setPreview(image: UIImage, title: String) {
        cardTitleLabel.text = title
        previewImageView.image = image
        
        let titleAreaHeight: CGFloat = 36
        let imageRatio = image.size.height / image.size.width
        let cardWidth: CGFloat = 143
        let imageHorizontalInset: CGFloat = 4
        let imageWidth = cardWidth - (imageHorizontalInset * 2)
        let calculatedHeight = imageWidth * imageRatio + titleAreaHeight + 16
        
        cardContainerView.snp.remakeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(143)
            $0.height.equalTo(calculatedHeight)
        }
        view.layoutIfNeeded()
    }
    
    private func setLayout() {
        navigationView.addSubviews(closeButton, titleLabel)
        cardContainerView.addSubviews(cardTitleLabel, previewImageView)
        view.addSubviews(navigationView, cardContainerView, subtextLabel, saveButton)
        
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(56)
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(closeButton.snp.trailing).offset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        cardContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(143)
//            $0.height.equalTo(538)
        }
        
        cardTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        previewImageView.snp.makeConstraints {
            $0.top.equalTo(cardTitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(4)
            $0.bottom.equalToSuperview().inset(8)
        }

        subtextLabel.snp.makeConstraints {
            $0.bottom.equalTo(saveButton.snp.top).offset(-16)
            $0.centerX.equalToSuperview()
        }

        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.height.equalTo(56)
        }
    }
}

