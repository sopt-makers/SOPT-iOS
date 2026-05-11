//
//  SoptletterWritingVC.swift
//  SoptletterFeature
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

import SnapKit
import Then

import BaseFeatureDependency

public final class SoptletterWritingVC: UIViewController, SoptletterViewControllable {

    // MARK: - Properties

    public let viewModel: SoptletterWritingViewModel
    private let cancelBag = CancelBag()

    private let maxCharCount = 250
    private let textChangedSubject = PassthroughSubject<String, Never>()
    private let submitTapSubject = PassthroughSubject<Void, Never>()
    private var isSettingAttributedText = false

    private lazy var naviBackTap: Driver<Void> = backButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    // MARK: - UI Components (NavBar)

    private let navBarView = UIView()

    private let backButton = UIButton(type: .custom).then {
        $0.setImage(DSKitAsset.Assets.opArrowWhite.image, for: .normal)
    }

    private let navTitleLabel = UILabel().then {
        $0.text = I18N.Soptletter.navigationTitle
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.font = DSKitFontFamily.Pretendard.bold.font(size: 18)
    }

    // MARK: - UI Components (Description)

    private let descriptionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 14
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 4, right: 20)
    }

    private let mailBoxImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icMailBox.image
        $0.contentMode = .scaleAspectFit
    }

    private let descriptionLabel = UILabel().then {
        $0.text = I18N.Soptletter.descriptionText
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.numberOfLines = 0
    }

    // MARK: - UI Components (Input Container)

    private let inputContainerView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray700.color
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0
    }

    private let recipientLabel = UILabel().then {
        $0.text = I18N.Soptletter.recipient
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
    }

    private let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 16)
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
        $0.isScrollEnabled = false
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }

    private let placeholderLabel = UILabel().then {
        $0.text = I18N.Soptletter.placeholder
        $0.textColor = DSKitAsset.Colors.gray500.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 16)
        $0.numberOfLines = 0
    }

    private let charCountLabel = UILabel().then {
        $0.text = I18N.Soptletter.charLimit
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
    }

    // MARK: - UI Components (Submit Button)

    private let submitButton = AppCustomButton(title: I18N.Soptletter.submitButton)
        .setEnabled(false)
        .setConfigForState(
            bgColor: DSKitAsset.Colors.gray100.color,
            disabledColor: DSKitAsset.Colors.gray600.color,
            disabledTextColor: DSKitAsset.Colors.white.color,
            disabledFont: DSKitFontFamily.Suit.semiBold.font(size: 16),
            enabledTextColor: DSKitAsset.Colors.gray300.color,
            enabledFont: DSKitFontFamily.Suit.semiBold.font(size: 16)
        )

    // MARK: - Init

    public init(viewModel: SoptletterWritingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        bindViewModels()
        hideKeyboard()
    }
}

// MARK: - UI & Layout

private extension SoptletterWritingVC {
    func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        navigationController?.navigationBar.isHidden = true
        textView.delegate = self
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    func setLayout() {
        descriptionStackView.addArrangedSubview(mailBoxImageView)
        descriptionStackView.addArrangedSubview(descriptionLabel)

        view.addSubviews(navBarView, descriptionStackView, inputContainerView, submitButton)
        navBarView.addSubviews(backButton, navTitleLabel)
        inputContainerView.addSubviews(recipientLabel, textView, placeholderLabel, charCountLabel)

        navBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }

        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }

        navTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(12)
            make.centerY.equalTo(backButton)
        }

        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(navBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        mailBoxImageView.snp.makeConstraints { make in
            make.width.equalTo(96)
            make.height.equalTo(80)
        }

        inputContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(19)
        }

        recipientLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(recipientLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(charCountLabel.snp.top).offset(-16)
            make.height.greaterThanOrEqualTo(120)
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(textView)
        }

        charCountLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(20)
        }

        submitButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(34)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
    }

    func bindViewModels() {
        let input = SoptletterWritingViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            naviBackTap: naviBackTap,
            textChanged: textChangedSubject.asDriver(),
            submitTap: submitTapSubject.asDriver()
        )

        let output = self.viewModel.transform(from: input, cancelBag: cancelBag)

        output.isSubmitEnabled
            .receive(on: RunLoop.main)
            .withUnretained(self)
            .sink { owner, isEnabled in
                owner.submitButton.isEnabled = isEnabled
            }.store(in: cancelBag)
    }

    @objc func submitButtonTapped() {
        submitTapSubject.send(())
    }
}

// MARK: - UITextViewDelegate

extension SoptletterWritingVC: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        guard !isSettingAttributedText else { return }

        let text = textView.text ?? ""
        placeholderLabel.isHidden = !text.isEmpty
        updateCharCount(text.count)
        updateErrorState(text: text)
        textChangedSubject.send(text)
    }

    private func updateCharCount(_ count: Int) {
        charCountLabel.text = "\(count)/250자"
        charCountLabel.textColor = count > maxCharCount
            ? DSKitAsset.Colors.error.color
            : DSKitAsset.Colors.gray300.color
    }

    private func updateErrorState(text: String) {
        let isOver = text.count > maxCharCount
        inputContainerView.layer.borderWidth = isOver ? 1 : 0
        inputContainerView.layer.borderColor = isOver ? DSKitAsset.Colors.error.color.cgColor : nil

        guard isOver else {
            if textView.textColor != DSKitAsset.Colors.gray200.color {
                textView.textColor = DSKitAsset.Colors.gray200.color
            }
            return
        }

        let attributed = NSMutableAttributedString(string: text)
        let normalFont = DSKitFontFamily.Suit.regular.font(size: 16)
        attributed.addAttributes([
            .foregroundColor: DSKitAsset.Colors.gray200.color,
            .font: normalFont
        ], range: NSRange(location: 0, length: maxCharCount))
        attributed.addAttributes([
            .foregroundColor: DSKitAsset.Colors.error.color,
            .font: normalFont
        ], range: NSRange(location: maxCharCount, length: text.count - maxCharCount))

        let selectedRange = textView.selectedRange
        isSettingAttributedText = true
        textView.attributedText = attributed
        textView.selectedRange = selectedRange
        isSettingAttributedText = false
    }
}
