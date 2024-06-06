//
//  PokeOnboardingViewController.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/13/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import BaseFeatureDependency
import Core
import Domain
import DSKit

import SnapKit

// 3. collectionView 이상한것 수정
// 4. pokeAPI도 수정 (query 추가)

public final class PokeOnboardingViewController: UIViewController, PokeOnboardingViewControllable {
  // MARK: - Constants
  private enum Metric {
    static let navigationbarHeight = 44.f
    
    static let titleLabelTop = 16.f
    
    static let containerViewTop = 7.f
    static let containerViewLeadingTrailing = 20.f
    
    static let collectionViewHeight = 586.f
    
    static let pageIndicatorTop = 14.f
    static let pageIndicatorHeight = 10.f
    
    static let bottomDescriptionLabelTop = 10.f
  }
  
  private enum Constant {
    static let numberOfSections = 1
    static let numberOfItemsPerRow = 2
    
    static let numberOfFooterDesciprionLines = 2
  }
  
  // MARK: - Views
  private let navigationBar = PokeOnboardingNavigationBar()
  
  private let scrollView = UIScrollView().then {
    $0.alwaysBounceVertical = true
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
    $0.isScrollEnabled = true
  }
  
  private let scrollContainerStackView = UIView()
  // MARK: Title
  private let pokeTitleLabel = UILabel().then {
    $0.attributedText = I18N.Poke.Onboarding.title.applyMDSFont(
      mdsFont: .title5,
      color: DSKitAsset.Colors.gray30.color
    )
  }
  
  private lazy var collectionView = UICollectionView(
    frame: self.view.frame,
    collectionViewLayout: self.flowLayout
  ).then {
    $0.register(
      PokeOnboardingCollectionViewCell.self,
      forCellWithReuseIdentifier: PokeOnboardingCollectionViewCell.className
    )
    $0.dataSource = self
    $0.delegate = self
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.isPagingEnabled = true
  }
  
  private let flowLayout = PokeCarouselFlowLayout()

  private let contentFooterDescriptionLabel = UILabel().then {
    $0.attributedText = I18N.Poke.Onboarding.footerPullToRefreshDescription.applyMDSFont(
      mdsFont: .title7,
      color: DSKitAsset.Colors.gray200.color,
      alignment: .center
    )
    $0.numberOfLines = Constant.numberOfFooterDesciprionLines
  }
  
  // MARK: Sections
  private let refreshControl = UIRefreshControl()
  private let pageIndicator = UIPageControl().then {
    $0.numberOfPages = 3
    $0.currentPage = 0
  }
  
  // MARK: - Variables
  private let viewModel: PokeOnboardingViewModel
  private var contentModels: [PokeRandomUserInfoModel] = []
  private var cancelBag = CancelBag()
  
  
  // MARK: Combine
  private let viewDidLoaded = PassthroughSubject<Void, Never>()
  private let pullToRefreshTriggered = PassthroughSubject<PokeRandomUserType, Never>()
  private let pokeButtonTapped = PassthroughSubject<PokeUserModel, Never>()
  private let avatarTapped = PassthroughSubject<PokeUserModel, Never>()
  private let messageCommandClicked = PassthroughSubject<PokeMessageModel, Never>()
  
  public init(viewModel: PokeOnboardingViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - View Lifecycles
extension PokeOnboardingViewController {
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = DSKitAsset.Colors.gray950.color
    self.navigationController?.navigationBar.isHidden = true
    
    self.initializeViews()
    self.setupConstraints()
    self.setupRefreshControl()
    
    self.bindViews()
    self.bindViewModels()
    
    self.viewDidLoaded.send(())
  }
}

// MARK: - Configuring methods
extension PokeOnboardingViewController {
  private func configure(with contentModels: [PokeRandomUserInfoModel]) {
    contentModels.forEach { newModel in
      if let index = self.contentModels.firstIndex(where: { $0.randomType == newModel.randomType }) {
        self.contentModels[index] = newModel
      } else {
        self.contentModels.append(newModel)
      }
    }
    
    self.pageIndicator.numberOfPages = self.contentModels.count
    self.collectionView.reloadData()
  }
}

// MARK: - Private methods
extension PokeOnboardingViewController {
  private func initializeViews() {
    self.view.addSubviews(self.navigationBar, self.scrollView)
    
    self.scrollView.addSubview(self.scrollContainerStackView)
    
    self.scrollContainerStackView.addSubviews(
      self.pokeTitleLabel,
      self.collectionView,
      self.pageIndicator,
      self.contentFooterDescriptionLabel
    )
  }
  
  private func setupConstraints() {
    self.navigationBar.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.height.equalTo(Metric.navigationbarHeight)
    }
    
    self.scrollView.snp.makeConstraints {
      $0.top.equalTo(self.navigationBar.snp.bottom).offset(Metric.titleLabelTop)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    self.scrollContainerStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.width.height.equalToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
    }
    
    self.pokeTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Metric.containerViewLeadingTrailing)
    }
    
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.pokeTitleLabel.snp.bottom).offset(Metric.containerViewTop)
      $0.leading.trailing.width.equalToSuperview()
      $0.height.equalTo(Metric.collectionViewHeight)
    }
    
    self.pageIndicator.snp.makeConstraints {
      $0.top.equalTo(self.collectionView.snp.bottom).offset(Metric.pageIndicatorTop)
      $0.height.equalTo(Metric.pageIndicatorHeight)
      $0.centerX.equalToSuperview()
    }
    
    self.contentFooterDescriptionLabel.snp.makeConstraints {
      $0.top.equalTo(self.pageIndicator.snp.bottom).offset(Metric.bottomDescriptionLabelTop)
      $0.centerX.bottom.lessThanOrEqualToSuperview()
    }
  }
}

extension PokeOnboardingViewController: UICollectionViewDelegateFlowLayout {
  public func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let pageWidth = collectionView.bounds.width 
    - Metric.containerViewLeadingTrailing * 2
    - self.flowLayout.minimumLineSpacing
    - Metric.containerViewLeadingTrailing * 2
    
    let targetXContentOffset = targetContentOffset.pointee.x
    let newPage = Int(targetXContentOffset / pageWidth)

    self.pageIndicator.currentPage = newPage
  }
}
extension PokeOnboardingViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.contentModels.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard
      let item = self.contentModels[safe: indexPath.item],
      let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: PokeOnboardingCollectionViewCell.className,
        for: indexPath
      ) as? PokeOnboardingCollectionViewCell
    else { return UICollectionViewCell() }
    
    cell.configure(with: item)
    
    cell.signalForAvatarClick()
      .sink(receiveValue: { userModel in
        self.avatarTapped.send(userModel)
      }).store(in: cell.cancelBag)
    
    cell.signalForPokeButtonClick()
      .sink(receiveValue: { userModel in
        self.pokeButtonTapped.send(userModel)
      }).store(in: cell.cancelBag)
    
    return cell
  }
}

// MARK: - ViewModel Methods
extension PokeOnboardingViewController {
  private func bindViews() {
    self.navigationBar
      .signalForClickLeftButton()
      .sink(receiveValue: { [weak self] _ in
        self?.dismiss(animated: true)
      }).store(in: self.cancelBag)
  }
  
  private func bindViewModels() {
    let input = PokeOnboardingViewModel.Input(
      viewDidLoaded: self.viewDidLoaded.asDriver(),
      pullToRefreshTriggered: self.pullToRefreshTriggered.asDriver(),
      pokeButtonTapped: self.pokeButtonTapped.asDriver(),
      avatarTapped: self.avatarTapped.asDriver(),
      messageCommandClicked: self.messageCommandClicked.asDriver()
    )
    
    let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    
    output
      .randomAcquaintance
      .sink(receiveCompletion: { [weak self] _ in
        self?.refreshControl.endRefreshing()
      }, receiveValue: { [weak self] randomUserInfoModels in
        self?.refreshControl.endRefreshing()
        self?.configure(with: randomUserInfoModels)
      }).store(in: self.cancelBag)
    
    output
      .pokedResult
      .sink(receiveValue: { [weak self] pokedResult in
        
        
//        self?.update(with: pokedResult)
      }).store(in: self.cancelBag)
  }
}

// MARK: - RefreshControl {
extension PokeOnboardingViewController {
  private func setupRefreshControl() {
    self.scrollView.refreshControl = self.refreshControl
    
    self.refreshControl
      .publisher(for: .valueChanged)
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .sink(receiveValue: { [weak self] index in
        let currentIndex = self?.pageIndicator.currentPage ?? 0
        let currentModel = self?.contentModels[safe: currentIndex]?.randomType ?? .all
        self?.pullToRefreshTriggered.send(currentModel)
      }).store(in: self.cancelBag)
  }
}
