//
//  PokeOnboardingCollectionViewCell.swift
//  PokeFeature
//
//  Created by Ian on 6/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import Core
import Domain

public final class PokeOnboardingCollectionViewCell: UICollectionViewCell {
  
  private lazy var sectionView = PokeOnboardingSectionView(frame: self.frame)
  
  private(set) var cancelBag = CancelBag()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.initialize()
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PokeOnboardingCollectionViewCell {
  public func configure(with randomUserInfoModel: PokeRandomUserInfoModel) {
    self.sectionView.configure(with: randomUserInfoModel)
  }
}

extension PokeOnboardingCollectionViewCell {
  public func signalForAvatarClick() -> AnyPublisher<PokeUserModel, Never> {
    self.sectionView.signalForAvatarClick()
  }
  
  public func signalForPokeButtonClick() -> AnyPublisher<PokeUserModel, Never> {
    self.sectionView.signalForPokeButtonClick()
  }
}

extension PokeOnboardingCollectionViewCell {
  private func initialize() {
    self.contentView.addSubview(self.sectionView)
  }
  
  private func setupConstraints() {
    self.sectionView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
  }
}
