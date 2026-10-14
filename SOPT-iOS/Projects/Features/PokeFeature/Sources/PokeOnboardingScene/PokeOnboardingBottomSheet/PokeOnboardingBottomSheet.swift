//
//  PokeOnboardingBottomSheet.swift
//  PokeFeature
//
//  Created by Ian on 12/17/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import MDS
import DSKit

// MARK: - PokeOnboardingBottomSheet

public class PokeOnboardingBottomSheet: UIViewController {
  private enum Metric {
    static let contentTop = 24.f
    static let contentLeadingTrailng = 20.f
    
    static let titleLabelTop = 12.f
    
    static let onboardingImageHeight = 180.f
    
    static let doneButtonTop = 20.f
    static let doneButtonLeadingTrailng = 16.f
  }
  
  private let contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = Metric.titleLabelTop
  }
  
  private let titleLabel = UILabel().then {
      $0.text = I18N.Poke.Onboarding.title
      $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
  }
  
  private let onboardingImageView = UIImageView().then {
      $0.contentMode = .scaleAspectFit
    $0.image = DSKitAsset.Assets.iosImgOnboarding.image
  }
  
  private let onboardingDescriptionLabel = UILabel().then {
      $0.numberOfLines = 0
      $0.textAlignment = .left
      $0.text = I18N.Poke.Onboarding.description
      $0.setTypography(Typography.body2, textColor: SemanticColor.Fg.Neutral.bold)
  }
    
    private lazy var doneButton = MDSActionButton(
        variant: .primary,
        size: .large,
        title: I18N.Default.ok
    )
  
  // MARK: - Variables
  private let cancelBag = CancelBag()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
      // TODO: - BG 컬러 피그마 반영 후 수정 (요청 상태)
      self.view.backgroundColor = SemanticColor.Bg.Layer.default
    
    self.initializeViews()
    self.setupConstraints()
    
    self.doneButton
      .publisher(for: .touchUpInside)
      .withUnretained(self)
      .sink(receiveValue: { owner, _ in
          owner.dismiss(animated: true)
      }).store(in: self.cancelBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PokeOnboardingBottomSheet {
  private func initializeViews() {
    self.view.addSubviews(
      self.contentStackView,
      self.doneButton
    )
    
    self.contentStackView.addArrangedSubviews(
      self.titleLabel,
      self.onboardingImageView,
      self.onboardingDescriptionLabel
    )
  }
  
  private func setupConstraints() {
    self.contentStackView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(Metric.contentTop)
      $0.leading.trailing.equalToSuperview().inset(Metric.contentLeadingTrailng)
    }
    
    self.onboardingImageView.snp.makeConstraints {
      $0.height.equalTo(Metric.onboardingImageHeight)
    }
    
    self.doneButton.snp.makeConstraints {
      $0.top.equalTo(self.contentStackView.snp.bottom).offset(Metric.doneButtonTop)
      $0.leading.trailing.equalToSuperview().inset(Metric.doneButtonLeadingTrailng)
      
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }
}
