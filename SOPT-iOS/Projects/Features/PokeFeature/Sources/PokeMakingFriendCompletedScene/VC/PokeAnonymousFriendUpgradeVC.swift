//
//  PokeAnonymousFriendUpgradeVC.swift
//  PokeFeature
//
//  Created by Aiden.lee on 2024/06/02.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine
import Lottie
import SnapKit
import Then

import Core
import DSKit
import Domain

import PokeFeatureInterface
import BaseFeatureDependency

public class PokeAnonymousFriendUpgradeVC: UIViewController, PokeAnonymousFriendUpgradePresentable  {

  // MARK: - Properties

  private let user: PokeUserModel

  // MARK: - UI Components

  private let titleLabel = UILabel().then {
    $0.font = UIFont.MDS.title3
    $0.textColor = DSKitAsset.Colors.gray10.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }

  private lazy var lottieView = LottieAnimationView(name: lottieName(user: user),
                                               bundle: DSKitResources.bundle)

  private let profileImageView = PokeProfileImageView().then {
    $0.isHidden = true
  }

  private let descriptionLabel = UILabel().then {
    $0.font = UIFont.MDS.title5
    $0.textColor = DSKitAsset.Colors.gray10.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }

  private lazy var containerStackView = UIStackView(
    arrangedSubviews: [
      titleLabel,
      lottieView,
      descriptionLabel
    ]
  ).then {
    $0.axis = .vertical
    $0.spacing = 6
    $0.alignment = .center
  }

  // MARK: - initialization

  init(user: PokeUserModel) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Life Cycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    dismissIfNeeded()
    setUI()
    setLayout()
  }

  // MARK: - Method

  private func dismissIfNeeded() {
    if user.pokeNum != 5 && user.pokeNum != 11 {
      self.dismiss(animated: false)
    }
  }

  private func setLottie() {
    lottieView.loopMode = .playOnce
    lottieView.contentMode = .scaleAspectFit
    lottieView.play { [weak self] _ in
      guard let self else { return }
      if user.pokeNum == 5 {
        self.lottieView.stop()
        self.dismiss(animated: false)
        return
      }

      if user.pokeNum == 11 {
        showRealIdentity()
        return
      }

      self.dismiss(animated: false)
    }
  }

  private func showRealIdentity() {
    titleLabel.text = "\(user.anonymousName)님의 정체는..."
    profileImageView.isHidden = false
    profileImageView.setImage(with: user.profileImage, relation: user.pokeRelation)
    descriptionLabel.text = "\(user.generation)기 \(user.part)파트 \(user.name)"

    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      self.dismiss(animated: false)
    }
  }
}

// MARK: - UI & Layout

extension PokeAnonymousFriendUpgradeVC {
  private func setUI() {
    self.titleLabel.text = makeTitle()
    self.view.backgroundColor = DSKitAsset.Colors.gray950.color.withAlphaComponent(0.8)
    setLottie()

    if user.pokeNum == 5 {
      descriptionLabel.text = "\(user.generation)기 \(user.part)파트"
    }
  }

  private func setLayout() {
    self.view.addSubviews(containerStackView, profileImageView)

    lottieView.snp.makeConstraints { make in
      make.width.height.equalTo(200)
    }

    containerStackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(36)
    }

    containerStackView.setCustomSpacing(34, after: lottieView)

    profileImageView.snp.makeConstraints { make in
      make.center.equalTo(lottieView)
      make.width.height.equalTo(170)
    }
  }

  private func lottieName(user: PokeUserModel) -> String {
    if user.pokeNum == 5 {
      return "bestFriend"
    }
    return "soulmate"
  }

  private func makeTitle() -> String {
    if user.pokeRelation == .bestFriend {
      return "\(user.anonymousName)님과\n\(user.relationName)가 되었어요!"
    }
    return "\(user.anonymousName)님과\n\(user.relationName)이 되었어요!"
  }
}

