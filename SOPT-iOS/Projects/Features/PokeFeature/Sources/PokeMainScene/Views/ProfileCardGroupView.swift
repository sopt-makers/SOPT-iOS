//
//  ProfileCardGroupView.swift
//  PokeFeature
//
//  Created by sejin on 12/8/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit
import Domain

public final class ProfileCardGroupView: UIView, PokeCompatible {

  // MARK: - Properties

  lazy var kokButtonTap: Driver<PokeUserModel?> = leftProfileCardView.kokButtonTap
    .merge(with: rightProfileCardView.kokButtonTap)
    .asDriver()

  lazy var profileImageTap: Driver<PokeUserModel?> = Publishers.Merge(leftProfileCardView.profileTapped,
                                                                      rightProfileCardView.profileTapped).asDriver()

  let cancelBag = CancelBag()

  private var friendPlaygroundId: Int?

  // MARK: - UI Components

  private let groupNameLabel = UILabel().then {
    $0.textColor = DSKitAsset.Colors.gray30.color
    $0.font = UIFont.MDS.title7.font
  }

  private let emptyFriendView = PokeEmptyView().setText(with: I18N.Poke.emptyFriendDescription)

  private let leftProfileCardView = PokeProfileCardView(frame: .zero).then {
    $0.isHidden = true
  }

  private let rightProfileCardView = PokeProfileCardView(frame: .zero).then {
    $0.isHidden = true
  }

  // MARK: - initialization

  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setUI()
    self.setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI & Layout

extension ProfileCardGroupView {
  private func setUI() {
    self.backgroundColor = DSKitAsset.Colors.gray900.color
    self.layer.cornerRadius = 8
  }

  private func setLayout() {
    self.addSubviews(groupNameLabel, emptyFriendView, leftProfileCardView, rightProfileCardView)

    groupNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(8)
      make.leading.equalToSuperview().inset(12)
    }

    emptyFriendView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(groupNameLabel.snp.bottom).offset(32)
    }

    leftProfileCardView.snp.makeConstraints { make in
      make.width.equalTo(130)
      make.top.equalTo(groupNameLabel.snp.bottom).offset(4)
      make.centerX.equalToSuperview().multipliedBy(0.55)
      make.bottom.equalToSuperview().inset(8)
    }

    rightProfileCardView.snp.makeConstraints { make in
      make.width.equalTo(130)
      make.top.equalTo(groupNameLabel.snp.bottom).offset(4)
      make.centerX.equalToSuperview().multipliedBy(1.45)
      make.bottom.equalToSuperview().inset(8)
    }
  }
}

// MARK: - Methods

extension ProfileCardGroupView {

  func setData(with model: PokeRandomInfoListModel) {
    self.groupNameLabel.text = model.randomTitle
    let randomUsers = model.userInfoList.prefix(2)

    handleProfileCardCount(count: randomUsers.count)

    for (index, user) in randomUsers.enumerated() {
      index == 0 ? leftProfileCardView.setData(with: user) : rightProfileCardView.setData(with: user)
    }
  }

  private func handleProfileCardCount(count: Int) {
    emptyFriendView.isHidden = count != 0
    leftProfileCardView.isHidden = count < 1
    rightProfileCardView.isHidden = count < 2
  }

  func changeUIAfterPoke(newUserModel: PokeUserModel) {
    leftProfileCardView.changeUIAfterPoke(newUserModel: newUserModel)
    rightProfileCardView.changeUIAfterPoke(newUserModel: newUserModel)
  }
}
