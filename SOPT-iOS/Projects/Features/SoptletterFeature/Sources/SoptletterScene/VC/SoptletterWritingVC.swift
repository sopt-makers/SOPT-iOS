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
import MDS

import SnapKit
import Then

import BaseFeatureDependency

public final class SoptletterWritingVC: UIViewController, SoptletterViewControllable {

    // MARK: - Properties

    public let viewModel: SoptletterWritingViewModel
    private let cancelBag = CancelBag()

    private let maxCharCount = 350
    private let textChangedSubject = PassthroughSubject<String, Never>()
    private var isSettingAttributedText = false
    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?

    private lazy var naviBackTap: Driver<Void> = backButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    private lazy var submitButtonTap: Driver<Void> = submitButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navBarView = UIView()

    private let backButton = UIButton(type: .custom).then {
        $0.setImage(MDSIcon.chevronLeftOutlined.image, for: .normal)
    }

    private let navTitleLabel = UILabel().then {
        $0.text = I18N.Soptletter.navigationTitle
        $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
    }

    // MARK: - UI Components

    private let descriptionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 14
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
    }

    private let mailBoxImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icMailBox.image
        $0.contentMode = .scaleAspectFit
    }

    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.setTypography(Typography.body2, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private let inputContainerView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.ghost
        $0.layer.cornerRadius = BaseRadius.Base.r10
        $0.layer.borderWidth = 0
    }

    private let recipientLabel = UILabel().then {
        $0.text = I18N.Soptletter.recipient
        $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.bold)
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
        $0.isScrollEnabled = false
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }

    private let placeholderLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = I18N.Soptletter.placeholder
        $0.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.ghost)
    }

    private let charCountLabel = UILabel().then {
        $0.text = I18N.Soptletter.charLimit
        $0.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle)
    }

    private let submitButton = MDSActionButton(variant: .secondary,
                                               size: .large,
                                               title: I18N.Soptletter.submitButton)

    // MARK: - Init

    public init(viewModel: SoptletterWritingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        if let keyboardWillShowObserver {
            NotificationCenter.default.removeObserver(keyboardWillShowObserver)
        }
        if let keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(keyboardWillHideObserver)
        }
    }

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        bindViewModels()
        setKeyboardObserver()
        hideKeyboard()
    }
}

// MARK: - UI & Layout

private extension SoptletterWritingVC {
    func setUI() {
        view.backgroundColor = SemanticColor.Bg.Layer.basement
        navigationController?.navigationBar.isHidden = true
        textView.delegate = self
    }

    func setLayout() {
        descriptionStackView.addArrangedSubview(mailBoxImageView)
        descriptionStackView.addArrangedSubview(descriptionLabel)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(navBarView, descriptionStackView, inputContainerView, submitButton)
        navBarView.addSubviews(backButton, navTitleLabel)
        inputContainerView.addSubviews(recipientLabel, textView, placeholderLabel, charCountLabel)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }

        navBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }

        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(BaseSpacing.Base.s16)
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.width.height.equalTo(24)
        }

        navTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(BaseSpacing.Base.s12)
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
            make.top.equalTo(descriptionStackView.snp.bottom).offset(BaseSpacing.Base.s10)
            make.leading.trailing.equalToSuperview().inset(19)
        }

        recipientLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(BaseSpacing.Base.s28)
            make.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(recipientLabel.snp.bottom).offset(BaseSpacing.Base.s14)
            make.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.bottom.equalTo(charCountLabel.snp.top).offset(-BaseSpacing.Base.s10)
            make.height.greaterThanOrEqualTo(120)
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(textView)
        }

        charCountLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(BaseSpacing.Base.s20)
        }

        submitButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(inputContainerView.snp.bottom).offset(BaseSpacing.Base.s20)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
        }
    }

    func setKeyboardObserver() {
        keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.scrollInputContainerToTop()
        }

        keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.scrollView.setContentOffset(.zero, animated: true)
        }
    }

    func scrollInputContainerToTop() {
        let targetOffsetY = max(0, inputContainerView.frame.minY - 10)
        scrollView.setContentOffset(CGPoint(x: 0, y: targetOffsetY), animated: true)
    }

    func bindViewModels() {
        let input = SoptletterWritingViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            naviBackTap: naviBackTap,
            textChanged: textChangedSubject.asDriver(),
            submitTap: submitButtonTap
        )

        let output = self.viewModel.transform(from: input, cancelBag: cancelBag)

        output.isSubmitEnabled
            .receive(on: RunLoop.main)
            .withUnretained(self)
            .sink { owner, isEnabled in
                owner.submitButton.isEnabled = isEnabled
            }.store(in: cancelBag)
    }
}

// MARK: - UITextViewDelegate

extension SoptletterWritingVC: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: text)
        if updatedText.count == maxCharCount + 1 {
            ToastUtils.showMDSToast(type: .alert, text: I18N.Soptletter.charLimitError)
        }
        return updatedText.count <= maxCharCount + 1
    }

    public func textViewDidChange(_ textView: UITextView) {
        guard !isSettingAttributedText else { return }

        let text = textView.text ?? ""
        placeholderLabel.isHidden = !text.isEmpty
        updateCharCount(text.count)
        updateErrorState(text: text)
        textChangedSubject.send(text)
    }

    private func updateCharCount(_ count: Int) {
        charCountLabel.text = "\(count)/\(maxCharCount)자"
        let textColor = count > maxCharCount
            ? SemanticColor.Fg.Danger.default
            : SemanticColor.Fg.Neutral.subtle
        charCountLabel.setTypography(Typography.label3, textColor: textColor)
    }

    private func updateErrorState(text: String) {
        let isOver = text.count > maxCharCount
        inputContainerView.layer.borderWidth = isOver ? 1 : 0
        inputContainerView.layer.borderColor = isOver ? SemanticColor.Stroke.Danger.default.cgColor : nil

        guard isOver else {
            if textView.textColor != SemanticColor.Fg.Neutral.bold {
                textView.textColor = SemanticColor.Fg.Neutral.bold
            }
            return
        }

        let attributed = NSMutableAttributedString(string: text)
        let normalFont = Typography.body1.font
        attributed.addAttributes([
            .foregroundColor: SemanticColor.Fg.Neutral.bold,
            .font: normalFont
        ], range: NSRange(location: 0, length: maxCharCount))
        attributed.addAttributes([
            .foregroundColor: SemanticColor.Fg.Danger.default,
            .font: normalFont
        ], range: NSRange(location: maxCharCount, length: text.count - maxCharCount))

        let selectedRange = textView.selectedRange
        isSettingAttributedText = true
        textView.attributedText = attributed
        textView.selectedRange = selectedRange
        isSettingAttributedText = false
    }
}
