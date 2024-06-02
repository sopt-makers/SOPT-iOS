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

public final class PokeOnboardingViewController: UIViewController, PokeOnboardingViewControllable {
  // MARK: - Constants
  private enum Metric {
    static let navigationbarHeight = 44.f
    
    static let titleLabelTop = 16.f
    
    static let containerViewTop = 7.f
    static let containerViewLeadingTrailing = 20.f
    static let containerCornerRadius = 8.f
    
    static let stackViewTopBottom = 8.f
    static let stackViewLeadingTrailing = 12.f
    static let contentVerticalSpacing = 8.f
    
    static let descriptionLabelTop = 16.f
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
  
  private let scrollContainerStackView = UIStackView().then {
    $0.alignment = .fill
    $0.axis = .vertical
    $0.spacing = 16.f
  }
  
  // MARK: Title
  private let pokeTitleLabel = UILabel().then {
    $0.attributedText = I18N.Poke.Onboarding.title.applyMDSFont(
      mdsFont: .title5,
      color: DSKitAsset.Colors.gray30.color
    )
  }
  
  // MARK: Sections
  private let sectionContentView = UIView().then {
    $0.layer.cornerRadius = Metric.containerCornerRadius
    $0.backgroundColor = DSKitAsset.Colors.gray900.color
  }
  
  private let sectionTitleLabel = UILabel().then {
    $0.text = "나와 같은 34기를 하고 있어요"
    $0.textColor = DSKitAsset.Colors.gray30.color
    $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
  }
  
  private let sectionItemStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = Metric.contentVerticalSpacing
  }
  
  // MARK: Description
  private let contentFooterDescriptionLabel = UILabel().then {
    $0.attributedText = I18N.Poke.Onboarding.footerPullToRefreshDescription.applyMDSFont(
      mdsFont: .title7,
      color: DSKitAsset.Colors.gray200.color,
      alignment: .center
    )
    $0.numberOfLines = Constant.numberOfFooterDesciprionLines
  }
  
  private let refreshControl = UIRefreshControl()
  
  // MARK: - Variables
  private let viewModel: PokeOnboardingViewModel
  private var contentModels: [PokeUserModel] = []
  private var cancelBag = CancelBag()
  
  // MARK: Combine
  private let viewDidLoaded = PassthroughSubject<Void, Never>()
  private let pullToRefreshTriggered = PassthroughSubject<Void, Never>()
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
  private func configure(with contentModels: [PokeUserModel]) {
    self.contentModels = contentModels
    self.sectionItemStackView.removeAllSubViews()
    
    let splitedArray: [[PokeUserModel]] = self.splitArrayIntoSizeTwoChunks(originArray: contentModels)
    
    splitedArray.forEach {
      let contentView = PokeOnboardingHorizontalStackView(frame: self.view.frame)
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
  
  private func update(with contentModel: PokeUserModel) {
    if let index = self.contentModels.firstIndex(where: { $0.userId == contentModel.userId }) {
      self.contentModels[index] = contentModel
    }
    
    self.configure(with: self.contentModels)
  }
}

// MARK: - Private methods
extension PokeOnboardingViewController {
  private func initializeViews() {
    self.view.addSubviews(self.navigationBar, self.scrollView)
    
    self.scrollView.addSubview(self.scrollContainerStackView)
    
    self.scrollContainerStackView.addArrangedSubviews(
      self.pokeTitleLabel,
      self.sectionContentView,
      self.contentFooterDescriptionLabel
    )
    
    self.sectionContentView.addSubviews(
      self.sectionTitleLabel,
      self.sectionItemStackView
    )
    
    self.scrollContainerStackView.setCustomSpacing(Metric.containerViewTop, after: self.pokeTitleLabel)
    self.scrollContainerStackView.setCustomSpacing(Metric.descriptionLabelTop, after: self.sectionContentView)
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
      $0.top.leading.trailing.equalToSuperview().inset(Metric.containerViewLeadingTrailing)
      $0.width.equalToSuperview().inset(Metric.containerViewLeadingTrailing)
    }
    
    self.sectionTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Metric.stackViewTopBottom)
      $0.leading.trailing.equalToSuperview().inset(Metric.stackViewLeadingTrailing)
    }
    
    self.sectionItemStackView.snp.makeConstraints {
      $0.top.equalTo(self.sectionTitleLabel.snp.bottom).offset(Metric.contentVerticalSpacing)
      $0.leading.trailing.equalToSuperview().inset(Metric.stackViewLeadingTrailing)
      $0.bottom.equalToSuperview().inset(Metric.stackViewTopBottom)
    }
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
      }, receiveValue: { [weak self] acquaintances in
        self?.refreshControl.endRefreshing()
        self?.configure(with: acquaintances)
      }).store(in: self.cancelBag)
    
    output
      .pokedResult
      .sink(receiveValue: { [weak self] pokedResult in
        self?.update(with: pokedResult)
      }).store(in: self.cancelBag)
  }
}

// MARK: - RefreshControl {
extension PokeOnboardingViewController {
  private func setupRefreshControl() {
    self.scrollView.refreshControl = self.refreshControl
    self.refreshControl.addTarget(self, action: #selector(self.handleRefreshControl), for: .valueChanged)
  }
  
  @objc private func handleRefreshControl() {
    self.pullToRefreshTriggered.send(())
  }
}

extension PokeOnboardingViewController {
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
