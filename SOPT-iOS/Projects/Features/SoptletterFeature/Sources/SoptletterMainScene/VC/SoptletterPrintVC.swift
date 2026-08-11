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
import MDS
import Domain

public final class SoptletterPrintVC: UIViewController {
    
    // MARK: - UI Properties
    
    private let navigationView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Layer.basement
    }

    private let closeButton = UIButton().then {
        $0.setImage(MDSIcon.chevronLeftOutlined.image, for: .normal)
    }

    private lazy var naviBackButtonTap: Driver<Void> = closeButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    private let titleLabel = UILabel().then {
        $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
        $0.textAlignment = .left
        $0.text = I18N.Soptletter.Print.printButtonTitle
    }

    private let cardContainerView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.ghost
        $0.layer.cornerRadius = BaseRadius.Base.r12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = SemanticColor.Stroke.Neutral.Default.focused.cgColor
        $0.clipsToBounds = true
    }

    private let previewImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }

    private let subtextLabel = UILabel().then {
        $0.text = I18N.Soptletter.Print.previewTitle
        $0.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle)
        $0.textAlignment = .center
    }

    private let saveButton = MDSActionButton(variant: .secondary,
                                             size: .large,
                                             title: I18N.Soptletter.Print.savePdfButtonTitle)
    
    // MARK: - Properties
    
    private let viewModel: SoptletterPrintViewModel
    private let previewImage: UIImage
    private let cancelBag = CancelBag()
    
    private lazy var saveButtonTap: Driver<Void> = saveButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    // MARK: - Initilizer
    
    public init(viewModel: SoptletterPrintViewModel, uiImage: UIImage) {
        self.viewModel = viewModel
        self.previewImage = uiImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setPreview(image: previewImage)
        bindViewModels()
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
        view.backgroundColor = SemanticColor.Bg.Layer.basement
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setPreview(image: UIImage) {
        previewImageView.image = image

        let imageRatio = image.size.height / image.size.width
        let cardWidth: CGFloat = 148
        let imageHorizontalInset: CGFloat = 4
        let imageWidth = cardWidth - (imageHorizontalInset * 2)
        let calculatedHeight = imageWidth * imageRatio + 16

        cardContainerView.snp.remakeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(BaseSpacing.Base.s20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(cardWidth)
            $0.height.equalTo(calculatedHeight)
        }
        view.layoutIfNeeded()
    }
    
    private func setLayout() {
        navigationView.addSubviews(closeButton, titleLabel)
        cardContainerView.addSubviews(previewImageView)
        view.addSubviews(navigationView, cardContainerView, subtextLabel, saveButton)
        
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(56)
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.directionalVerticalEdges.equalToSuperview().inset(BaseSpacing.Base.s16)
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(closeButton.snp.trailing).offset(BaseSpacing.Base.s12)
            make.directionalVerticalEdges.equalToSuperview().inset(BaseSpacing.Base.s16)
        }

        cardContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(BaseSpacing.Base.s20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(148)
        }

        previewImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(BaseSpacing.Base.s4)
            $0.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s4)
            $0.bottom.equalToSuperview().inset(BaseSpacing.Base.s8)
        }

        subtextLabel.snp.makeConstraints {
            $0.bottom.equalTo(saveButton.snp.top).offset(-11)
            $0.centerX.equalToSuperview()
        }

        saveButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s20)
        $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

