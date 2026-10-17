//
//  PokeNotificationListContentView.swift
//  PokeFeature
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import MDS

import UIKit
import Domain

final public class PokeNotificationListContentView: UIView, PokeCompatible {
  private enum Metrics {
    static let contentDefaultSpacing = 8.f
    static let leftToCenterContentPadding = 12.f
    static let profileAvatarLength = 50.f

    static let centerToRightContentPadding = 8.f
    static let centerTopContentPadding = 8.f

    static let centerSeperateContentsMinHeight = 22.f

    static let centerContentPaddingAfterDescription = 4.f
  }

  private enum Constant {
    static let numberOfLinesForDetailView = 2
    static let defaultNumberOfLines = 1
  }

  // MARK: - ContentStack
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = Metrics.contentDefaultSpacing
    $0.alignment = .center
  }

  // MARK: Left:
  private let profileImageView = MDSAvatar(size: Metrics.profileAvatarLength)

  // MARK: Center:
  private lazy var centerContentsStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .leading
  }
  private lazy var centerTopContentsStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = Metrics.centerTopContentPadding
    $0.alignment = .center
  }

  // Center-Top
  private let nameLabel = UILabel().then {
      $0.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold, alignment: .left)
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  private let partInfoLabel = UILabel().then {
      $0.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle, alignment: .left)
  }

  // Center-middle
  private lazy var descriptionLabel = UILabel().then {
    $0.numberOfLines = self.isDetailView ? Constant.numberOfLinesForDetailView : Constant.defaultNumberOfLines
  }

  // Center-bottom
  private lazy var pokeChipView = PokeChipView(frame: self.frame)

  // MARK: Right:
  private let pokeKokButton = PKokButton()

  // NOTE: NotifcationDetailView에서는 description의 numberOfLine Value가 2에요
  private let isDetailView: Bool

  private var userId: Int?
  var user: PokeUserModel?

  lazy var kokButtonTap: Driver<PokeUserModel?> = pokeKokButton.tap
        .withUnretained(self)
        .map({ owner, _ in
            owner.user
        }).asDriver()

  lazy var profileImageTap = profileImageView.gesture()
        .withUnretained(self)
        .filter({ owner, _ in
            owner.user?.isAnonymous == false
        })
        .map({ owner, _ in
            owner.user
        }).asDriver()

  // MARK: - View Lifecycle
  public init(
    isDetailView: Bool = true,
    frame: CGRect
  ) {
    self.isDetailView = isDetailView

    super.init(frame: frame)

    self.initializeViews()
    self.setupConstraint()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PokeNotificationListContentView {
  private func initializeViews() {
    self.addSubview(self.contentStackView)

    self.contentStackView.addArrangedSubviews(
      self.profileImageView,
      self.centerContentsStackView,
      self.pokeKokButton
    )

    self.centerContentsStackView.addArrangedSubviews(
      self.centerTopContentsStackView,
      self.descriptionLabel,
      self.pokeChipView
    )

    self.centerTopContentsStackView.addArrangedSubviews(
      self.nameLabel,
      self.partInfoLabel
    )

    self.contentStackView.setCustomSpacing(
      Metrics.leftToCenterContentPadding,
      after: self.centerContentsStackView
    )

    self.centerContentsStackView.setCustomSpacing(
      Metrics.centerContentPaddingAfterDescription,
      after: self.descriptionLabel
    )
  }

  private func setupConstraint() {
    self.contentStackView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }

    self.centerTopContentsStackView.snp.makeConstraints { $0.height.equalTo(Metrics.centerSeperateContentsMinHeight) }
    self.descriptionLabel.snp.makeConstraints { $0.height.greaterThanOrEqualTo(Metrics.centerSeperateContentsMinHeight) }
    self.profileImageView.snp.makeConstraints { $0.size.equalTo(Metrics.profileAvatarLength) }
  }
}

extension PokeNotificationListContentView {
  public func configure(with model: PokeUserModel) {
    self.user = model
    self.userId = model.userId
    self.profileImageView.setImage(
        with: model.isAnonymous ? "" : model.profileImage,
        relation: PokeRelation(rawValue: model.relationName) ?? .nonFriend
    )
    self.partInfoLabel.text = "\(model.generation)기 \(model.part)"
      self.partInfoLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle, alignment: .left)
      self.descriptionLabel.text = model.message
      self.descriptionLabel.setTypography(Typography.body2, textColor: SemanticColor.Fg.Neutral.bold)
    self.pokeChipView.configure(with: model.mutualRelationMessage)
    self.pokeKokButton.isEnabled = !model.isAlreadyPoke
    // 익명이면 데이터 숨김처리
    self.pokeChipView.isHidden = model.isAnonymous
    self.partInfoLabel.isHidden = model.isAnonymous
    if model.isAnonymous {
      configureAnonymous(model: model)
      return
    }
    self.nameLabel.text = model.name
      self.nameLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold, alignment: .left)
  }

  func configureAnonymous(model: PokeUserModel) {
    self.nameLabel.text = model.anonymousName
      self.nameLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold, alignment: .left)
  }

  func setData(with model: PokeUserModel) {
    self.configure(with: model)
  }

  func changeUIAfterPoke(newUserModel: PokeUserModel) {
    guard let user, user.userId == newUserModel.userId else { return }

    self.setData(with: newUserModel)
  }

  public func signalForPokeButtonClicked() -> Driver<PokeUserModel> {
    self.pokeKokButton
      .tap
      .compactMap { [weak self] _ in self?.user }
      .asDriver()
  }

}
