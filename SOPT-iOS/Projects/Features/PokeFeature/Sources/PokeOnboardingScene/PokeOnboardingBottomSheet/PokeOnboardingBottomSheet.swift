//
//  PokeOnboardingBottomSheet.swift
//  PokeFeature
//
//  Created by Ian on 12/17/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

// MARK: - PokeOnboardingBottomSheet
public class PokeOnboardingBottomSheet: UIViewController {
  private enum Metric {
    static let contentTop = 24.f
    static let contentLeadingTrailng = 20.f
    
    static let titleLabelTop = 12.f
    
    static let onboardingImageHeight = 180.f
    
    static let descriptionTop = 8.f
    
    static let doneButtonTop = 34.f
    static let doneButtonLeadingTrailng = 16.f
  }
  
  private let contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = Metric.titleLabelTop
  }
  
  private let titleLabel = UILabel().then {
    $0.text = I18N.Poke.Onboarding.title
    $0.textColor = DSKitAsset.Colors.gray30.color
    $0.font = DSKitFontFamily.Suit.bold.font(size: 20)
  }
  
  private let onboardingImageView = UIImageView().then {
    $0.image = DSKitAsset.Assets.iosImgOnboarding.image
  }
  
  private let onboardingDescriptionLabel = UILabel().then {
    $0.text = I18N.Poke.Onboarding.description
    $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
    $0.textColor = DSKitAsset.Colors.gray30.color
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }
  
  private lazy var doneButton = MDSButton(
    buttonSize: .medium,
    leftImage: nil,
    buttonTitle: "확인",
    rightImage: nil,
    frame: self.view.frame
  )
  
  // MARK: - Variables
  private let cancelBag = CancelBag()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    self.view.backgroundColor = DSKitAsset.Colors.gray800.color
    
    self.initializeViews()
    self.setupConstraints()
    
    self.doneButton
      .signalForButtonClick()
      .withUnretained(self)
      .sink(receiveValue: { _ in 
        self.dismiss(animated: true)
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
      $0.top.greaterThanOrEqualTo(self.contentStackView.snp.bottom).offset(Metric.doneButtonTop)
      $0.leading.trailing.equalToSuperview().inset(Metric.doneButtonLeadingTrailng)
      
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }
}

// MARK: - MDSButton
public class MDSButton: UIView {
  // TODO: 버튼 타입, 사이즈, 타입에 따른 색, Radius, content item의 tintColor 규칙 명세 확인하고 적용하기 @승호
  // Button hugging 규칙 같은것도 정리해야 해요
  // MARK: - Types
  public enum ButtonSize {
    case small
    case medium
    case large
  }
  
  // MARK: - Subviews
  private let contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4.f
  }
  
  private let leftImageView = UIImageView().then {
    $0.isHidden = true
  }
  private let titleLabel = UILabel().then {
    $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    $0.textAlignment = .center
  }
  private let rightImageView = UIImageView().then {
    $0.isHidden = true
  }
  
  // MARK: Variables
  private let buttonSize : ButtonSize
  
  init(
    buttonSize: ButtonSize,
    leftImage: UIImage?,
    buttonTitle: String,
    rightImage: UIImage?,
    frame: CGRect
  ) {
    self.buttonSize = buttonSize
    
    super.init(frame: frame)
    
    if let leftImage {
      self.leftImageView.isHidden = false
      self.leftImageView.image = leftImage
    }
    
    self.titleLabel.text = buttonTitle
    
    if let rightImage {
      self.rightImageView.isHidden = false
      self.rightImageView.image = rightImage
    }
    
    self.initializeViews()
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MDSButton {
  private func initializeViews() {
    self.addSubview(self.contentStackView)
    
    self.contentStackView.addArrangedSubviews(
      self.leftImageView,
      self.titleLabel,
      self.rightImageView
    )
    
    // TBD: 버튼 규칙 확인 후 아래 내용 수정하기
    self.layer.cornerRadius = 10.f
    self.backgroundColor = DSKitAsset.Colors.white.color
    self.titleLabel.textColor = DSKitAsset.Colors.black.color
  }
  
  private func setupConstraints() {
    // TBD: 버튼 규칙 확인 후 아래 내용 수정하기
    self.snp.makeConstraints {
      $0.height.equalTo(42.f)
    }
    
    self.contentStackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(12.f)
      $0.leading.trailing.equalToSuperview().inset(20.f)
    }
  }
}

extension MDSButton {
  public func signalForButtonClick() -> Driver<Void> {
    return self.gesture().mapVoid().asDriver()
  }
}
