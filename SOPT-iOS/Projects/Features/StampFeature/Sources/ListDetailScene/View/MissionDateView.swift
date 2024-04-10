//
//  MissionDateView.swift
//  StampFeature
//
//  Created by Ian on 4/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import Core
import DSKit

public final class MissionDateView: UIView {
  private enum Metric {
    static let contentTop = 9.f
    static let contentLeadingTrailing = 14.f
    static let contentBottom = 10.f
    
    static let toolBarHeight = 44.f
    static let chevronLength = 20.f
  }
  
  private enum Constant {
    static let cornerRadius = 9.f
  }
  
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 0.f
  }
  
  private lazy var textField = UITextField().then {
    $0.attributedPlaceholder = self.getAttributedString(I18N.ListDetail.missionDatePlaceHolder)
    $0.textColor = DSKitAsset.Colors.soptampGray600.color
    $0.font = .SoptampFont.caption1
  }
  private let rightChevron = UIImageView().then {
    $0.image = DSKitAsset.Assets.iconChevronRight.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Colors.gray600.color
  }
  
  // MARK: - Private Variables
  private var cancelBag = CancelBag()
  private var selectAndFormattedDate: String?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = DSKitAsset.Colors.soptampGray50.color
    self.layer.cornerRadius = Constant.cornerRadius
    
    self.initializeViews()
    self.initializeDatePicker()
    
    self.setupConstraints()
    
    self.textField
      .publisher(for: .editingDidBegin)
      .compactMap { $0.text }
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] text in
        self?.setTextFieldView(.active)
      }).store(in: self.cancelBag)

      
    self.textField
      .publisher(for: .editingDidEnd)
      .compactMap { $0.text }
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] text in
        guard text.isEmpty else { return }
        
        self?.setTextFieldView(.inactive)
      }).store(in: self.cancelBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public functions
extension MissionDateView {
  public func setText(with dateText: String) {
    self.textField.attributedText = self.getAttributedString(dateText)
  }
  
  public func setIsEnabled(_ isEnabled: Bool) {
    self.textField.isEnabled = isEnabled
  }
  
  public func setBorderLayerColor(to pointColor: CGColor) {
    self.layer.borderColor = pointColor
  }
  
  public func getText() -> String? {
    self.textField.text
  }
  
  public func setTextFieldView(_ state: TextViewState) {
    switch state {
    case .inactive:
      self.backgroundColor = DSKitAsset.Colors.soptampGray50.color
      self.layer.borderWidth = .zero
    case .active:
      self.backgroundColor = DSKitAsset.Colors.soptampWhite.color
      self.layer.borderWidth = 1
    case .completed:
      self.backgroundColor = DSKitAsset.Colors.soptampGray50.color
      self.layer.borderWidth = .zero
    }
  }

}

// MARK: - Private Extensions
private extension MissionDateView {
  func getAttributedString(_ text: String) -> NSAttributedString {
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: DSKitAsset.Colors.soptampGray600.color
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
  }
}

// MARK: - Private functions
extension MissionDateView {
  private func initializeViews() {
    self.addSubview(self.contentStackView)
    
    self.contentStackView.addArrangedSubviews(self.textField, self.rightChevron)
  }
  
  private func setupConstraints() {
    self.contentStackView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Metric.contentTop)
      $0.leading.trailing.equalToSuperview().inset(Metric.contentLeadingTrailing)
      $0.bottom.equalToSuperview().inset(Metric.contentBottom)
    }
    
    self.rightChevron.snp.makeConstraints { $0.size.equalTo(Metric.chevronLength) }
  }
    
  private func initializeDatePicker() {
    let toolBarView = self.getInitializedToolBar()
    let datePicker = UIDatePicker().then {
      $0.datePickerMode = .date
      $0.locale = Locale(identifier: "ko-kr")
      $0.preferredDatePickerStyle = .wheels
    }
    
    datePicker
      .publisher(for: .valueChanged)
      .map { $0.date }
      .sink(receiveValue: { [weak self] value in
        let dateFormatter = DateFormatter().then {
          $0.dateFormat = "yyyy.MM.dd"
          $0.locale = .current
        }
        let formattedDate = dateFormatter.string(from: value)
        self?.selectAndFormattedDate = formattedDate
        self?.textField.text = formattedDate
      }).store(in: self.cancelBag)
    
    self.textField.inputView = datePicker
    self.textField.inputAccessoryView = toolBarView
  }
  
  private func getInitializedToolBar() -> UIToolbar {
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: Metric.toolBarHeight))
    let resetButton = UIBarButtonItem(
      title: I18N.ListDetail.datePickerCancelButtonTitle,
      style: .plain,
      target: nil,
      action: nil
    )
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(
      title: I18N.ListDetail.datePickerDoneButtonTitle,
      style: .plain,
      target: target,
      action: nil
    )
    
    resetButton
      .tapPublisher
      .asDriver()
      .sink(receiveValue: { [weak self] _ in
        self?.textField.text = ""
        self?.textField.resignFirstResponder()
      }).store(in: self.cancelBag)
    
    doneButton
      .tapPublisher
      .asDriver()
      .sink(receiveValue: { [weak self] _ in
        let date: String
        if let selectAndFormattedDate = self?.selectAndFormattedDate {
          date = selectAndFormattedDate
        } else {
          let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy.MM.dd"
            $0.locale = .current
          }
          date = dateFormatter.string(from: Date())
        }
        self?.textField.text = date
        self?.textField.resignFirstResponder()
      }).store(in: self.cancelBag)
    
    toolBar.setItems([resetButton, flexible, doneButton], animated: false)
    
    return toolBar
  }
}
