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
import MDS

final class MissionDateView: UIView {
    private enum Metric {
        static let toolBarHeight = 44
        static let chevronLength = 20
    }

    private enum Constant {
        static let cornerRadius = BaseRadius.Base.r10
    }

    private lazy var contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
    }

    private lazy var textField = UITextField().then {
        $0.attributedPlaceholder = self.getAttributedString(
            I18N.ListDetail.missionDatePlaceHolder,
            color: SemanticColor.Fg.Neutral.ghost
        )
        $0.setTypography(Typography.label3,
                         textColor: SemanticColor.Fg.Neutral.default)
    }
    private let rightChevron = UIImageView().then {
        $0.image = MDSIcon.chevronRightOutlined.image.withTintColor(SemanticColor.Fg.Neutral.subtle)
    }
    
    public var textFieldDidEdited: Driver<Void> {
        self.textField
            .publisher(for: .allEditingEvents)
            .mapVoid()
            .asDriver()
    }
    
    // MARK: - Private Variables
    private var cancelBag = CancelBag()
    private var selectAndFormattedDate: String?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = SemanticColor.Bg.Layer.default
        self.layer.cornerRadius = Constant.cornerRadius
        self.layer.borderColor = SemanticColor.Stroke.Neutral.Default.focused.cgColor
        
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
        self.textField.attributedText = self.getAttributedString(dateText, color: SemanticColor.Fg.Neutral.bold)
    }
    
    public func setIsEnabled(_ isEnabled: Bool) {
        self.textField.isEnabled = isEnabled
    }
    
    public func getText() -> String? {
        self.textField.text
    }
    
    public func setTextFieldView(_ state: TextViewState) {
        switch state {
        case .inactive:
            self.layer.borderWidth = .zero
        case .active:
            self.layer.borderWidth = 1
            self.textField.textColor = SemanticColor.Fg.Neutral.bold
        case .completed:
            self.layer.borderWidth = .zero
            self.textField.textColor = SemanticColor.Fg.Neutral.bold
        }
    }
}

// MARK: - Private Extensions
private extension MissionDateView {
    func getAttributedString(_ text: String, color: UIColor) -> NSAttributedString {
        let attributes = Typography.label3.attributedStringAttributes(foregroundColor: color)
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
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(14)
        }
        
        self.rightChevron.snp.makeConstraints { $0.size.equalTo(Metric.chevronLength)
        }
    }
    
    private func initializeDatePicker() {
        let toolBarView = self.getInitializedToolBar()
        let datePicker = UIDatePicker().then {
            $0.datePickerMode = .date
            $0.locale = Locale(identifier: "ko-kr")
            $0.preferredDatePickerStyle = .wheels
            $0.maximumDate = Date()
        }
        
        datePicker
            .publisher(for: .valueChanged)
            .map { $0.date }
            .sink(receiveValue: { [weak self] value in
                DateFormatManager.shared.setFormat(.dateWithDot)
                let formattedDate = DateFormatManager.shared.dateToString(value)
                self?.selectAndFormattedDate = formattedDate
                self?.textField.text = formattedDate
            }).store(in: self.cancelBag)
        
        self.textField.inputView = datePicker
        self.textField.inputAccessoryView = toolBarView
    }
    
    private func getInitializedToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Int(self.frame.width), height: Metric.toolBarHeight))
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
                    DateFormatManager.shared.setFormat(.dateWithDot)
                    date = DateFormatManager.shared.dateToString(Date())
                }
                self?.textField.text = date
                self?.textField.resignFirstResponder()
            }).store(in: self.cancelBag)
        
        toolBar.setItems([resetButton, flexible, doneButton], animated: false)
        
        return toolBar
    }
}
