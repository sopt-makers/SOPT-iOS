//
//  PokeMessageTemplateBottomSheet.swift
//  PokeFeature
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import BaseFeatureDependency
import Core
import DSKit
import Domain

public final class PokeMessageTemplateBottomSheet: UIViewController, PokeMessageTemplatesViewControllable {
  private enum Metric {
    static let contentTop = 24.f
    static let contentLeadingTrailng = 20.f
    
    static let scrollViewTop = 12.f
    
    static let anonymousStackViewSpacing = 8.f
    static let anonymousCheckboxLength = 22.f
    
    static let contentStackViewSpacing = 4.f
  }
  
  // MARK: - Views
  private let scrollView = UIScrollView().then {
    $0.alwaysBounceVertical = true
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
    
    $0.isScrollEnabled = true
  }
  
  private let scrollContainerStackView = UIStackView().then {
    $0.alignment = .fill
    $0.axis = .vertical
    $0.spacing = Metric.contentStackViewSpacing
  }
  
  private let messegeTemplateTitleLabel = UILabel().then {
    $0.attributedText = "함께 보낼 메시지를 골라주세요".applyMDSFont(
      mdsFont: .heading5,
      color: DSKitAsset.Colors.gray30.color
    )
  }
  
  private let anonymousStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = Metric.anonymousStackViewSpacing
  }
  
  private let anonymousCheckboxButton = UIButton().then {
    $0.layer.cornerRadius = 5
    $0.setImage(DSKitAsset.Assets.check.image, for: .selected)
    $0.setBackgroundColor(DSKitAsset.Colors.gray500.color, for: .normal)
    $0.setBackgroundColor(DSKitAsset.Colors.blue40.color, for: .selected)
  }
  
  private let anonymousDescription = UILabel().then {
    $0.attributedText = "익명".applyMDSFont(
      mdsFont: .title6,
      color: DSKitAsset.Colors.gray10.color
    )
  }
  
  // MARK: - Variables
  private let viewModel: PokeMessageTemplateViewModel
  
  // MARK: Combine
  private let viewDidLoaded = PassthroughSubject<Void, Never>()
  private let messageModelSubject = PassthroughSubject<(PokeMessageModel, isAnonymous: Bool), Error>()
  private var cancelBag = CancelBag()
  
  init(viewModel: PokeMessageTemplateViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
    
    self.view.backgroundColor = DSKitAsset.Colors.gray800.color
    
    self.initializeViews()
    self.setupConstraints()
    self.bindViewModels()
    self.initializeButtonActions()
    
    self.viewDidLoaded.send(())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PokeMessageTemplateBottomSheet {
  private func initializeViews() {
    self.view.addSubviews(
      self.messegeTemplateTitleLabel,
      self.anonymousStackView,
      self.scrollView
    )
    
    self.anonymousStackView.addArrangedSubviews(
      self.anonymousCheckboxButton,
      self.anonymousDescription
    )
    
    self.scrollView.addSubview(self.scrollContainerStackView)
  }
  
  private func setupConstraints() {
    self.messegeTemplateTitleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(Metric.contentTop)
      $0.leading.trailing.equalToSuperview().inset(Metric.contentLeadingTrailng)
    }
    
    self.anonymousStackView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Metric.contentLeadingTrailng)
      $0.centerY.equalTo(self.messegeTemplateTitleLabel.snp.centerY)
    }
    
    self.anonymousCheckboxButton.snp.makeConstraints { $0.size.equalTo(Metric.anonymousCheckboxLength) }
    
    self.scrollView.snp.makeConstraints {
      $0.top.equalTo(self.messegeTemplateTitleLabel.snp.bottom).offset(Metric.scrollViewTop)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    self.scrollContainerStackView.snp.makeConstraints {
      $0.top.leading.trailing.width.equalToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
    }
  }
}

extension PokeMessageTemplateBottomSheet {
  func configure(with messagesModel: PokeMessagesModel) {
    self.messegeTemplateTitleLabel.text = messagesModel.header
    messagesModel.messages.forEach {
      let bottomsheetContentView = PokeBottomSheetMessageView(frame: self.view.frame)
      bottomsheetContentView.configure(with: $0)
      bottomsheetContentView
        .signalForClick()
        .sink(receiveValue: { [weak self] value in
          
          let isAnonymous = self?.anonymousCheckboxButton.isSelected ?? false
          self?.messageModelSubject.send((value, isAnonymous: isAnonymous))
          self?.dismiss(animated: true)
        }).store(in: self.cancelBag)
      
      self.scrollContainerStackView.addArrangedSubview(bottomsheetContentView)
    }
  }
  
  func signalForClick() -> Driver<(PokeMessageModel, isAnonymous: Bool)> {
    return self.messageModelSubject.asDriver()
  }
}


// MARK: - ViewModel Methods
extension PokeMessageTemplateBottomSheet {
  private func bindViewModels() {
    let input = PokeMessageTemplateViewModel.Input(viewDidLoaded: self.viewDidLoaded.asDriver())
    let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    
    output
      .messageTemplates
      .asDriver()
      .sink(receiveValue: { [weak self] values in
        self?.configure(with: values)
      }).store(in: self.cancelBag)
  }
  
  private func initializeButtonActions() {
    self.anonymousStackView
      .gesture()
      .map { _ in }
      .merge(with: self.anonymousCheckboxButton.publisher(for: .touchUpInside).map { _ in })
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] _ in
        self?.anonymousCheckboxButton.isSelected.toggle()
      }).store(in: self.cancelBag)
  }
}
