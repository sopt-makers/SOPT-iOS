//
//  MissionListVC.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine
import SnapKit
import Then

import StampFeatureInterface
import BaseFeatureDependency

public class MissionListVC: UIViewController, MissionListViewControllable {

  // MARK: - Properties

  public var viewModel: MissionListViewModel!
  public var sceneType: MissionListSceneType {
    return self.viewModel.missionListsceneType
  }
  private var cancelBag = CancelBag()

  private var missionTypeMenuSelected = CurrentValueSubject<MissionListFetchType, Never>(.all)
  private var viewWillAppear = PassthroughSubject<Void, Never>()
  private let swipeHandler = PassthroughSubject<Void, Never>()

  lazy var dataSource: UICollectionViewDiffableDataSource<MissionListSection, MissionListModel>! = nil

  // MARK: - MissionListCoordinatable

  public var onSwiped: (() -> Void)?
  public var onNaviBackTap: (() -> Void)?
  public var onPartRankingButtonTap: ((RankingViewType) -> Void)?
  public var onCurrentGenerationRankingButtonTap: ((RankingViewType) -> Void)?
  public var onGuideTap: (() -> Void)?
  public var onCellTap: ((MissionListModel, String?) -> Void)?
  public var onReportButtonTap: ((String) -> Void)?

  private var usersActiveGenerationStatus: UsersActiveGenerationStatusViewResponse?

  // MARK: - UI Components

  lazy var naviBar: STNavigationBar = {
    switch sceneType {
    case .default:
      return STNavigationBar(self, type: .title)
        .setTitle("전체 미션")
        .setTitleTypoStyle(.SoptampFont.h2)
        .setTitleButtonMenu(menuItems: self.menuItems)
        .addLeftButtonToTitleMenu()
    case .ranking(let username, _):
      return STNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(username)
        .setRightButton(.none)
        .setTitleTypoStyle(.SoptampFont.h2)
    }
  }()

  private lazy var menuItems: [UIAction] = {
    var menuItems: [UIAction] = []
    [("전체 미션", MissionListFetchType.all),
     ("완료 미션", MissionListFetchType.complete),
     ("미완료 미션", MissionListFetchType.incomplete)].forEach { menuTitle, fetchType in
      menuItems.append(UIAction(title: menuTitle,
                                handler: { _ in
        self.missionTypeMenuSelected.send(fetchType)
        self.naviBar.setTitle(menuTitle)
      }))
    }
    return menuItems
  }()

  private lazy var sentenceLabel: SentencePaddingLabel = {
    let lb = SentencePaddingLabel()
    if case let .ranking(_, sentence) = sceneType {
      lb.text = sentence
    }
    lb.setTypoStyle(.SoptampFont.subtitle1)
    lb.textColor = DSKitAsset.Colors.soptampGray900.color
    lb.numberOfLines = 2
    lb.textAlignment = .center
    lb.backgroundColor = DSKitAsset.Colors.soptampPurple100.color
    lb.layer.cornerRadius = 9.adjustedH
    lb.clipsToBounds = true
    lb.setCharacterSpacing(0)
    return lb
  }()

  private lazy var missionListCollectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    cv.showsVerticalScrollIndicator = true
    cv.backgroundColor = .white
    cv.bounces = false
    return cv
  }()

  private let missionListEmptyView = MissionListEmptyView()

  private lazy var floatingButtonStackView = UIStackView(frame: self.view.frame).then {
    $0.axis = .horizontal
    $0.spacing = 0.f
  }

  private lazy var currentGenerationRankFloatingButton: UIButton = {
    let bt = UIButton()
    bt.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    bt.layer.cornerRadius = 27.adjustedH
    bt.setBackgroundColor(DSKitAsset.Colors.soptampPurple300.color, for: .normal)
    bt.setBackgroundColor(DSKitAsset.Colors.soptampPurple300.color.withAlphaComponent(0.2), for: .selected)
    bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .normal)
    bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .highlighted)
    bt.tintColor = .white
    bt.titleLabel?.setTypoStyle(.SoptampFont.h2)
    bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
    bt.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    return bt
  }()

  private lazy var partRankingFloatingButton: UIButton = {
    let bt = UIButton()
    bt.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    bt.layer.cornerRadius = 27.adjustedH
    bt.setBackgroundColor(DSKitAsset.Colors.soptampPink300.color, for: .normal)
    bt.setBackgroundColor(DSKitAsset.Colors.soptampPink300.color.withAlphaComponent(0.2), for: .selected)
    bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .normal)
    bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .highlighted)
    bt.tintColor = .white
    bt.titleLabel?.setTypoStyle(.SoptampFont.h2)
    let attributedStr = NSMutableAttributedString(string: "파트별 랭킹")
    let style = NSMutableParagraphStyle()
    attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
    attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedStr.length))
    bt.setAttributedTitle(attributedStr, for: .normal)
    bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
    bt.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    return bt
  }()

  // MARK: - View Life Cycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
    self.setLayout()
    self.setDelegate()
    self.setGesture()
    self.registerCells()
    self.setDataSource()
    self.bindViews()
    self.bindViewModels()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewWillAppear.send(())
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
  }
}

// MARK: - UI & Layouts

extension MissionListVC {

  private func setUI() {
    self.view.backgroundColor = .white
    self.navigationController?.isNavigationBarHidden = true
  }

  private func setLayout() {
    self.view.addSubviews(naviBar, missionListCollectionView)

    naviBar.snp.makeConstraints { make in
      make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
    }

    missionListCollectionView.snp.makeConstraints { make in
      make.top.equalTo(naviBar.snp.bottom).offset(20.adjustedH)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }

    switch sceneType {
    case .default:
      self.view.addSubview(self.floatingButtonStackView)

      self.floatingButtonStackView.snp.makeConstraints { make in
        make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-18.adjustedH)
        make.centerX.equalToSuperview()
      }

      self.partRankingFloatingButton.snp.makeConstraints {
        $0.width.equalTo(143.adjusted)
        $0.height.equalTo(54.adjustedH)
      }

      self.currentGenerationRankFloatingButton.snp.makeConstraints {
        $0.width.equalTo(143.adjusted)
        $0.height.equalTo(54.adjustedH)
      }

    case .ranking:
      self.view.addSubview(sentenceLabel)

      sentenceLabel.snp.makeConstraints { make in
        make.top.equalTo(naviBar.snp.bottom).offset(10.adjustedH)
        make.leading.trailing.equalToSuperview().inset(20.adjusted)
        make.height.equalTo(64.adjustedH)
      }

      missionListCollectionView.snp.remakeConstraints { make in
        make.top.equalTo(sentenceLabel.snp.bottom).offset(16.adjustedH)
        make.leading.trailing.equalToSuperview()
        make.bottom.equalToSuperview()
      }
    }
  }
}

// MARK: - Methods

extension MissionListVC {
  private func bindViews() {

    naviBar.rightButtonTapped
      .asDriver()
      .withUnretained(self)
      .sink { owner, _ in
        owner.onGuideTap?()
      }.store(in: self.cancelBag)

    if case .default = sceneType {
      naviBar.leftButtonTapped
        .withUnretained(self)
        .sink { owner, _ in
          owner.onNaviBackTap?()
        }.store(in: self.cancelBag)
    }

    partRankingFloatingButton.publisher(for: .touchUpInside)
      .withUnretained(self)
      .sink { owner, _ in
        owner.onPartRankingButtonTap?(.partRanking)
      }.store(in: self.cancelBag)

    currentGenerationRankFloatingButton.publisher(for: .touchUpInside)
      .withUnretained(self)
      .sink { owner, _ in
        guard let usersActiveGenerationStatus = owner.usersActiveGenerationStatus else { return }

        owner.onCurrentGenerationRankingButtonTap?(.currentGeneration(info: usersActiveGenerationStatus))
      }.store(in: self.cancelBag)

    swipeHandler
      .first()
      .withUnretained(self)
      .sink { owner, _ in
        owner.onSwiped?()
      }.store(in: self.cancelBag)
  }
    
  private func bindViewModels() {
    let input = MissionListViewModel.Input(
      viewDidLoad: Driver<Void>.just(()),
      viewWillAppear: viewWillAppear.asDriver(),
      missionTypeSelected: missionTypeMenuSelected
    )
      
    let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)

    naviBar.reportButtonTapped
      .withUnretained(self)
      .sink { owner, _ in
          guard let url = output.reportUrl?.reportUrl else { return }
          owner.onReportButtonTap?(url)
      }.store(in: cancelBag)
      
    output.$missionListModel
      .compactMap { $0 }
      .sink { [weak self] model in
          self?.setCollectionView(model: model)
      }.store(in: self.cancelBag)

    output.$usersActivateGenerationStatus
      .compactMap { $0 }
      .sink { [weak self] generationStatus in
        guard generationStatus.status == .ACTIVE else { return }

        self?.usersActiveGenerationStatus = generationStatus
        self?.remakeButtonConstraint()
        self?.configureCurrentGenerationButton(with: String(describing: generationStatus.currentGeneration))
      }.store(in: self.cancelBag)

  }
}

extension MissionListVC {

  private func setDelegate() {
    missionListCollectionView.delegate = self
  }

  private func setGesture() {
    self.setGesture(to: missionListCollectionView)
    self.setGesture(to: missionListEmptyView)
  }

  private func setGesture(to view: UIView) {
    let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeBack(_:)))
    swipeGesture.delegate = self
    view.addGestureRecognizer(swipeGesture)
  }

  @objc
  private func swipeBack(_ sender: UIPanGestureRecognizer) {
    let velocity = sender.velocity(in: self.view)
    let velocityMinimum: CGFloat = 1000
    guard let navigation = self.navigationController else { return }
    let isScrollY: Bool = abs(velocity.x) > abs(velocity.y) + 200
    let isNotRootView = navigation.viewControllers.count >= 2
    if velocity.x >= velocityMinimum
        && isNotRootView
        && isScrollY {
      self.missionListCollectionView.isScrollEnabled = false
      swipeHandler.send(())
    }
  }

  private func registerCells() {
    MissionListCVC.register(target: missionListCollectionView)
  }

  private func setDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: missionListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      switch MissionListSection.type(indexPath.section) {
      case .sentence:
        guard let sentenceCell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCVC.className, for: indexPath) as? MissionListCVC else { return UICollectionViewCell() }
        return sentenceCell

      case .missionList:
        guard let missionListCell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCVC.className, for: indexPath) as? MissionListCVC else { return UICollectionViewCell() }
        let missionListModel = itemIdentifier
        missionListCell.initCellType = missionListModel.toCellType()
        missionListCell.setData(model: missionListModel)
        return missionListCell
      }
    })
  }

  func setCollectionView(model: [MissionListModel]) {
    if model.isEmpty {
      self.missionListCollectionView.isHidden = true
      self.missionListEmptyView.isHidden = false
      self.setEmptyView()
    } else {
      self.missionListCollectionView.isHidden = false
      self.missionListEmptyView.isHidden = true
      self.applySnapshot(model: model)
    }
  }

  private func setEmptyView() {
    missionListEmptyView.snp.removeConstraints()
    missionListEmptyView.removeFromSuperview()
    self.view.addSubviews(missionListEmptyView)
    missionListEmptyView.snp.makeConstraints { make in
      make.top.equalTo(naviBar.snp.bottom).offset(145.adjustedH)
      make.centerX.equalToSuperview()
      make.width.equalToSuperview()
      make.bottom.equalToSuperview().priority(.low)
    }
    bringRankingFloatingButtonToFront()
  }

  private func bringRankingFloatingButtonToFront() {
    self.view.subviews.forEach { view in
      if view == self.partRankingFloatingButton {
        self.view.bringSubviewToFront(partRankingFloatingButton)
      }
    }
  }

  private func applySnapshot(model: [MissionListModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<MissionListSection, MissionListModel>()
    snapshot.appendSections([.sentence, .missionList])
    snapshot.appendItems(model, toSection: .missionList)
    dataSource.apply(snapshot, animatingDifferences: false)
    self.view.setNeedsLayout()
  }

  private func remakeButtonConstraint() {
    self.floatingButtonStackView.addArrangedSubviews(self.currentGenerationRankFloatingButton, self.partRankingFloatingButton)
  }

  private func configureCurrentGenerationButton(with generation: String) {
    let attributedStr = NSMutableAttributedString(string: "\(generation)기 랭킹")
    let style = NSMutableParagraphStyle()
    attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
    attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedStr.length))
    self.currentGenerationRankFloatingButton.setAttributedTitle(attributedStr, for: .normal)
  }
}

// MARK: - UICollectionViewDelegate

extension MissionListVC: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    switch indexPath.section {
    case 0:
      return false
    case 1:
      switch self.sceneType {
      case .default:
        return true
      case .ranking:
        return true
      }
    default:
      return false
    }
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      return
    case 1:
      guard let tappedCell = collectionView.cellForItem(at: indexPath) as? MissionListCVC,
            let model = tappedCell.model else { return }
      onCellTap?(model, sceneType.usrename)
    default:
      return
    }
  }
}

extension MissionListVC: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
