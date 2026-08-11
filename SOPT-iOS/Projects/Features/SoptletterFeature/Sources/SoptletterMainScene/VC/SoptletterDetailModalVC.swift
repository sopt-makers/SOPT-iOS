//
//  SoptletterDetailVC.swift
//  SoptletterFeature
//
//  Created by dev on 6/29/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit

import BaseFeatureDependency
import Core
import DSKit
import MDS
import Domain

public final class SoptletterDetailModalVC: UIViewController {

    private let editButton = UIButton().then {
        $0.setImage(MDSIcon.writeOutlined.image.withTintColor(SemanticColor.Fg.Neutral.ghost), for: .normal)
    }

    private let deleteButton = UIButton().then {
        $0.setImage(MDSIcon.trashOutlined.image.withTintColor(SemanticColor.Fg.Neutral.ghost), for: .normal)
    }

    private let editDeleteStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = BaseSpacing.Base.s12
        $0.alignment = .center
        $0.isHidden = true
    }

    private let cancelEditButton = UIButton().then {
        $0.setImage(MDSIcon.xCloseOutlined.image.withTintColor(SemanticColor.Fg.Neutral.ghost), for: .normal)
        $0.isHidden = true
    }

    private let dimmedView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Dim.default.withAlphaComponent(0.8)
    }

    private let containerView = UIView().then {
        $0.layer.cornerRadius = BaseRadius.Base.r10
        $0.clipsToBounds = true
    }

    private let nameLabel = UILabel()

    private let contentScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }

    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private let contentTextView = UITextView().then {
        $0.font = Typography.body1.font
        $0.textColor = SemanticColor.Fg.Neutral.ghost
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
        $0.isHidden = true
    }

    private let charCountLabel = UILabel().then {
        $0.isHidden = true
    }

    private let maxContentLength = 350
    private var isEditingContent = false

    private let dateLabel = UILabel()

    private let likeButton = UIButton().then {
        $0.setImage(MDSIcon.heartOutlined.image.withTintColor(SemanticColor.Fg.Neutral.ghost), for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    private let likeCountLabel = UILabel()

    private let likeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = BaseSpacing.Base.s2
        $0.alignment = .center
    }

    private let confirmButton = MDSActionButton(variant: .secondary,
                                                size: .medium,
                                                title: I18N.Soptletter.Detail.confirmTitle)

    private lazy var cancelEditButtonTap: Driver<Void> = cancelEditButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    private lazy var editButtonTap: Driver<Void> = editButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    private lazy var deleteButtonTap: Driver<Void> = deleteButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    private lazy var confirmButtonTap: Driver<Void> = confirmButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    private lazy var likeButtonTap: Driver<(likeByMe: Bool, isMine:Bool)> = likeButton
        .publisher(for: .touchUpInside)
        .withUnretained(self)
        .map { owner, _ in (!owner.likeButton.isSelected, owner.isMine) }
        .asDriver()

    private let viewModel: SoptletterDetailViewModel
    private let cancelBag = CancelBag()
    private let editCompleteButtonTapPublisher = PassthroughSubject<String, Never>()

    private var containerViewCenterYConstraint: Constraint?
    private var likeCount = 0
    private var deleteButtonTapPublisher = PassthroughSubject<String, Never>()
    private var isMine = false

    private lazy var editCompleteButtonTap: Driver<String> = editCompleteButtonTapPublisher.asDriver()
    private lazy var deleteCompleteButtonTap: Driver<String> = deleteButtonTapPublisher.asDriver()

    public init(viewModel: SoptletterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        bindViewModels()
        addKeyboardObservers()
    }

    @discardableResult
    func configure(
        backgroundColor: UIColor = DSKitAsset.Colors.blue50.color,
        name: String,
        content: String,
        date: String,
        likeCount: Int,
        mine: Bool,
        likeByMe: Bool
    ) -> Self {
        self.likeCount = likeCount
        self.isMine = mine
        containerView.backgroundColor = backgroundColor

        nameLabel.text = name
        nameLabel.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.ghost)

        contentLabel.text = content
        contentLabel.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.ghost)

        dateLabel.text = DateFormatManager.shared.serverTimeToString(date, from: .dateWithDot)
        dateLabel.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.subtle)

        likeCountLabel.text = "\(likeCount)"
        likeCountLabel.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.ghost)

        editDeleteStackView.isHidden = !mine
        likeButton.setImage(
            (likeByMe ? MDSIcon.heartFilled.image : MDSIcon.heartOutlined.image).withTintColor(SemanticColor.Fg.Neutral.ghost),
            for: .normal
        )
        likeButton.isSelected = likeByMe
        return self
    }
}

extension SoptletterDetailModalVC {
    private func bindViewModels() {
        let input = SoptletterDetailViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            editButtonTap: editButtonTap,
            deleteButtonTap: deleteCompleteButtonTap,
            confirmButtonTap: confirmButtonTap,
            editCompleteButtonTap: editCompleteButtonTap,
            likeButtonTap: likeButtonTap
        )

        let output = self.viewModel.transform(from: input, cancelBag: cancelBag)

        likeButtonTap
            .withUnretained(self)
            .sink { owner, newLikeState in
                owner.applyLikeState(newLikeState.likeByMe)
            }.store(in: cancelBag)

        deleteButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.deleteButtonTapPublisher.send(owner.contentLabel.text ?? "")
            }.store(in: cancelBag)

        editButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.contentDisplayMode = .editing
            }.store(in: cancelBag)

        confirmButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                if owner.isEditingContent {
                    owner.editCompleteButtonTapPublisher.send(owner.contentTextView.text ?? "")
                } else {
                    owner.dismiss(animated: true)
                }
            }.store(in: cancelBag)

        cancelEditButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.contentDisplayMode = .viewing
            }.store(in: cancelBag)

        output.soptletterMessage
            .withUnretained(self)
            .sink { owner, model  in
                owner.configure(
                    backgroundColor: UIColor(hex: model.colorCode),
                    name: model.authorNickname,
                    content: model.content,
                    date: model.createdAt,
                    likeCount: model.likeCount,
                    mine: model.mine,
                    likeByMe: model.likedByMe
                )
            }.store(in: cancelBag)

        output.soptletterEditCompleted
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, _ in
                owner.contentLabel.text = owner.contentTextView.text
                owner.contentLabel.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.ghost)
                owner.contentDisplayMode = .viewing
                ToastUtils.showMDSToast(type: .success, text: I18N.Soptletter.Detail.editCompleteToast)
            }.store(in: cancelBag)

        output.soptletterDeleteCompleted
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, _ in
                owner.dismiss(animated: true)
                ToastUtils.showMDSToast(type: .success, text: I18N.Soptletter.Detail.deleteCompleteToast)
            }.store(in: cancelBag)

        // 좋아요 API 실패 시, 실패한 목표 상태(attemptedState)의 반대로 롤백
        output.soptletterLikeFailed
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, attemptedState in
                owner.applyLikeState(!attemptedState)
            }.store(in: cancelBag)
    }
}

private extension SoptletterDetailModalVC {
    func applyLikeState(_ isLiked: Bool) {
        guard likeButton.isSelected != isLiked else { return } // 중복 반영 방지

        likeButton.isSelected = isLiked
        likeButton.setImage(
            (isLiked ? MDSIcon.heartFilled.image : MDSIcon.heartOutlined.image).withTintColor(SemanticColor.Fg.Neutral.ghost),
            for: .normal
        )
        likeCount += isLiked ? 1 : -1
        likeCountLabel.text = "\(likeCount)"
        likeCountLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
    }

    func setUI() {
        view.backgroundColor = .clear
    }

    func setLayout() {
        editDeleteStackView.addArrangedSubviews(editButton, deleteButton)
        containerView.addSubview(editDeleteStackView)
        containerView.addSubview(cancelEditButton)
        likeStackView.addArrangedSubviews(likeButton, likeCountLabel)
        contentScrollView.addSubviews(contentLabel, contentTextView)
        containerView.addSubviews(nameLabel, contentScrollView, dateLabel, likeStackView, confirmButton, charCountLabel)
        view.addSubviews(dimmedView, containerView)

        editDeleteStackView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
        }

        cancelEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.size.equalTo(24)
        }

        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            self.containerViewCenterYConstraint = make.centerY.equalToSuperview().constraint
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(BaseSpacing.Base.s24)
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s20)
        }

        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(BaseSpacing.Base.s14)
            make.directionalHorizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.height.equalTo(312)
        }

        contentLabel.snp.makeConstraints { make in
             make.edges.equalToSuperview()
             make.width.equalTo(contentScrollView)
         }

         contentTextView.snp.makeConstraints { make in
             make.edges.equalToSuperview()
             make.width.equalTo(contentScrollView)
         }

         charCountLabel.snp.makeConstraints { make in
             make.top.equalTo(contentScrollView.snp.bottom).offset(BaseSpacing.Base.s8)
             make.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
         }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentScrollView.snp.bottom).offset(BaseSpacing.Base.s14)
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s20)
        }

        likeStackView.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(BaseSpacing.Base.s20)
        }

        likeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(BaseSpacing.Base.s10)
            make.directionalHorizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.bottom.equalToSuperview().inset(BaseSpacing.Base.s20)
        }
    }

    @objc func dimmedViewDidTap() {
        dismiss(animated: true)
    }

    func setDelegate() {
        contentTextView.delegate = self
    }
}

extension SoptletterDetailModalVC: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: text)
        if updatedText.count == maxContentLength + 1 {
            ToastUtils.showMDSToast(type: .alert, text: I18N.Soptletter.charLimitError)
        }
        return updatedText.count <= maxContentLength + 1
    }

    public func textViewDidChange(_ textView: UITextView) {
        updateCharCount(textView.text.count)
        updateConfirmButtonState(textView.text.count)
    }
}

private extension SoptletterDetailModalVC {
    func updateCharCount(_ count: Int) {
        charCountLabel.text = "\(count)/\(maxContentLength)자"
        let textColor = count > maxContentLength ? SemanticColor.Fg.Danger.default : SemanticColor.Fg.Neutral.subtle
        charCountLabel.setTypography(Typography.body2, textColor: textColor)
    }

    func updateConfirmButtonState(_ count: Int) {
        confirmButton.isEnabled = count <= maxContentLength
    }

}

extension SoptletterDetailModalVC {

    private enum ContentDisplayMode {
        case viewing
        case editing
    }

    private var contentDisplayMode: ContentDisplayMode {
        get { isEditingContent ? .editing : .viewing }
        set {
            isEditingContent = (newValue == .editing)
            apply(newValue)
        }
    }

    private func apply(_ mode: ContentDisplayMode) {
        let isEditing = mode == .editing

        if isEditing {
            contentTextView.text = contentLabel.text
            updateCharCount(contentTextView.text.count)
            updateConfirmButtonState(contentTextView.text.count)
        } else {
            confirmButton.isEnabled = true
        }

        contentLabel.isHidden = isEditing
        contentTextView.isHidden = !isEditing
        contentTextView.isEditable = isEditing
        charCountLabel.isHidden = !isEditing
        dateLabel.isHidden = isEditing
        likeStackView.isHidden = isEditing
        editDeleteStackView.isHidden = isEditing
        cancelEditButton.isHidden = !isEditing

        confirmButton.title = isEditing ? I18N.Soptletter.Detail.editCompleteTitle : I18N.Soptletter.Detail.confirmTitle

        _ = isEditing ? contentTextView.becomeFirstResponder() : contentTextView.resignFirstResponder()
    }
}

private extension SoptletterDetailModalVC {
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        // containerView 하단이 키보드 위 16pt 정도 여유를 두도록 오프셋 계산
        let containerBottomY = view.bounds.midY + (containerView.frame.height / 2)
        let overlap = containerBottomY - (view.bounds.height - keyboardHeight) + 16

        guard overlap > 0 else { return }

        containerViewCenterYConstraint?.update(offset: -overlap)

        let curve = UIView.AnimationOptions(rawValue: curveValue << 16)
        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        containerViewCenterYConstraint?.update(offset: 0)

        let curve = UIView.AnimationOptions(rawValue: curveValue << 16)
        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            self.view.layoutIfNeeded()
        }
    }
}
