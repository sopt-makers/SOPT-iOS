//
//  PokeOnboardingSectionView.swift
//  PokeFeature
//
//  Created by Ian on 6/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import Core
import DSKit
import Domain

public final class PokeOnboardingSectionView: UIView {
  private enum Metric {
    static let containerCornerRadius = 8.f
    static let containerTopBottom = 8.f
    static let contentVerticalSpacing = 8.f
    
    static let containerLeadingTrailing = 12.f
    
    static let titleLabelHeight = 24.f
  }
  
  private enum Constant {
    static let numberOfFooterDesciprionLines = 2
  }
  
  
  // MARK: - Views
  private let containerView = UIStackView().then {
    $0.axis = .vertical
  }
  
  private let sectionTitleLabel = UILabel()
  private let sectionItemStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = Metric.contentVerticalSpacing
  }
  
  // MARK: - Variables
  private var cancelBag = CancelBag()
  private var randomUserInfoModel: PokeRandomUserInfoModel?
  private var contentModels: [PokeUserModel] = []
  
  private let pokeButtonTapped = PassthroughSubject<PokeUserModel, Never>()
  private let avatarTapped = PassthroughSubject<PokeUserModel, Never>()

  // MARK: Lifecycles
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.initialize()
    self.setupConstraint()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Public methods
extension PokeOnboardingSectionView {
  public func configure(with randomUserInfoModel: PokeRandomUserInfoModel) {
    self.randomUserInfoModel = randomUserInfoModel
    self.sectionTitleLabel.attributedText = randomUserInfoModel.randomTitle.applyMDSFont(
      mdsFont: .heading7,
      color: DSKitAsset.Colors.gray30.color
    )
    self.sectionItemStackView.removeAllSubViews()
    
    let splitedArray: [[PokeUserModel]] = self.splitArrayIntoSizeTwoChunks(originArray: randomUserInfoModel.userInfoList)
    
    splitedArray.forEach {
      let contentView = PokeOnboardingHorizontalStackView(frame: self.frame)
      contentView.configure(with: $0)
      contentView
        .signalForPokeButtonClick()
        .asDriver()
        .sink(receiveValue: { [weak self] userModel in
          self?.pokeButtonTapped.send(userModel)
        }).store(in: self.cancelBag)
      
      contentView
        .signalForAvatarClick()
        .asDriver()
        .sink(receiveValue: { [weak self] userModel in
          self?.avatarTapped.send(userModel)
        }).store(in: self.cancelBag)
      
      self.sectionItemStackView.addArrangedSubview(contentView)
    }
  }
}

extension PokeOnboardingSectionView {
  public func signalForAvatarClick() -> AnyPublisher<PokeUserModel, Never> {
    self.avatarTapped.eraseToAnyPublisher()
  }
  
  public func signalForPokeButtonClick() -> AnyPublisher<PokeUserModel, Never> {
    self.pokeButtonTapped.eraseToAnyPublisher()
  }
}

extension PokeOnboardingSectionView {
  private func initialize() {
    self.layer.cornerRadius = Metric.containerCornerRadius
    self.backgroundColor = DSKitAsset.Colors.gray900.color
    
    self.addSubview(self.containerView)

    self.containerView.addArrangedSubviews(
      self.sectionTitleLabel,
      self.sectionItemStackView
    )
  }
  
  private func setupConstraint() {
    self.containerView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(Metric.containerTopBottom)
      $0.leading.trailing.equalToSuperview().inset(Metric.containerLeadingTrailing)
    }
    
    self.sectionTitleLabel.snp.makeConstraints {
      $0.height.equalTo(Metric.titleLabelHeight)
    }
  }
  
  private func splitArrayIntoSizeTwoChunks(originArray: [PokeUserModel]) -> [[PokeUserModel]] {
    var result: [[PokeUserModel]] = []
    var currentIndex = 0
    let chunkSize = 2
    
    while currentIndex < originArray.count {
      let endIndex = min(currentIndex + chunkSize, originArray.count)
      let chunk = Array(originArray[currentIndex..<endIndex])
      result.append(chunk)
      currentIndex += chunkSize
    }
    
    return result
  }
}
