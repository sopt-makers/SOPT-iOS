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
import Domain

public final class SoptletterDetailModalVC: UIViewController {
    
    private let editButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icSoptletterEdit.image, for: .normal)
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icSoptletterTrash.image, for: .normal)
    }
    
    private let editDeleteStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.isHidden = true
    }
    
    private let cancelEditButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = DSKitAsset.Colors.gray600.color
        $0.isHidden = true
    }
    
    private let dimmedView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray600.color
    }
    
    private let contentScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.regular.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray600.color
        $0.numberOfLines = 0
    }
    
    private let contentTextView = UITextView().then {
        $0.font = DSKitFontFamily.Suit.regular.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray600.color
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
        $0.isHidden = true
    }
    
    private let charCountLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.isHidden = true
    }

    private let maxContentLength = 350
    private var isEditingContent = false
    
    private let dateLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray300.color
    }
    
    private let likeImageView = UIImageView().then {
        $0.image = UIImage(systemName: "heart")
        $0.tintColor = DSKitAsset.Colors.gray700.color
        $0.contentMode = .scaleAspectFit
    }
    
    private let likeCountLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.textColor = DSKitAsset.Colors.gray700.color
    }
    
    private let likeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 12
    }
    
    private let viewModel: SoptletterDetailViewModel
    private let cancelBag = CancelBag()
    
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
    
    private let editCompleteButtonTapPublisher = PassthroughSubject<String, Never>()
    private lazy var editCompleteButtonTap: Driver<String> = editCompleteButtonTapPublisher
        .asDriver()
    
    public init(viewModel: SoptletterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModels()
    }
    
    @discardableResult
    func configure(
        backgroundColor: UIColor = DSKitAsset.Colors.blue50.color,
        name: String,
        content: String,
        date: String,
        likeCount: Int,
        mine: Bool
    ) -> Self {
        containerView.backgroundColor = backgroundColor
        nameLabel.text = name
        contentLabel.text = content
        dateLabel.text = date.toMMDDFormat()
        likeCountLabel.text = "\(likeCount)"
        editDeleteStackView.isHidden = !mine
        return self
    }
}

extension SoptletterDetailModalVC {
    private func bindViewModels() {
        let input = SoptletterDetailViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            editButtonTap: editButtonTap,
            deleteButtonTap: deleteButtonTap,
            confirmButtonTap: confirmButtonTap,
            editCompleteButtonTap: editCompleteButtonTap
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: cancelBag)
        
        editButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.enterEditingMode()
            }.store(in: cancelBag)

        confirmButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                if owner.isEditingContent {
                    let editedContent = owner.contentTextView.text ?? ""
                    owner.exitEditingMode()
                    owner.editCompleteButtonTapPublisher.send(editedContent)
                } else {
                    owner.dismiss(animated: true)
                }
            }.store(in: cancelBag)
        
        cancelEditButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.cancelEditingMode()
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
                    mine: model.mine
                )
            }.store(in: cancelBag)
    }
}

private extension SoptletterDetailModalVC {
    func setUI() {
        view.backgroundColor = .clear
    }
    
    func setLayout() {
        editDeleteStackView.addArrangedSubviews(editButton, deleteButton)
        containerView.addSubview(editDeleteStackView)
        containerView.addSubview(cancelEditButton)
        likeStackView.addArrangedSubviews(likeImageView, likeCountLabel)
        contentScrollView.addSubviews(contentLabel, contentTextView)
        containerView.addSubviews(nameLabel, contentScrollView, dateLabel, likeStackView, confirmButton, charCountLabel)
        view.addSubviews(dimmedView, containerView)
        
        editDeleteStackView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(20)
        }
        
        cancelEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }

        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(19)
            make.center.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
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
             make.top.equalTo(contentScrollView.snp.bottom).offset(4)
             make.trailing.equalToSuperview().inset(20)
         }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentScrollView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
        }
        
        likeStackView.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(20)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
    }
    
    @objc func dimmedViewDidTap() {
        dismiss(animated: true)
    }
}

extension SoptletterDetailModalVC: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        updateCharCount(textView.text.count)
        updateConfirmButtonState(textView.text.count)
    }
}

private extension SoptletterDetailModalVC {
    func updateCharCount(_ count: Int) {
        charCountLabel.text = "\(count)/\(maxContentLength)자"
        charCountLabel.textColor = count > maxContentLength ? .red : DSKitAsset.Colors.gray300.color
    }
    
    func updateConfirmButtonState(_ count: Int) {
        let isOverLimit = count > maxContentLength
        confirmButton.isEnabled = !isOverLimit
        confirmButton.backgroundColor = isOverLimit ? DSKitAsset.Colors.gray100.color : DSKitAsset.Colors.gray800.color
    }
    
    func enterEditingMode() {
        isEditingContent = true
        contentTextView.text = contentLabel.text
        contentTextView.delegate = self
        contentLabel.isHidden = true
        contentTextView.isHidden = false
        contentTextView.isEditable = true
        charCountLabel.isHidden = false
        updateCharCount(contentTextView.text.count)        
        updateConfirmButtonState(contentTextView.text.count)
        contentTextView.becomeFirstResponder()
        dateLabel.isHidden = true
        confirmButton.setTitle("수정완료", for: .normal)
        editDeleteStackView.isHidden = true
        cancelEditButton.isHidden = false
        likeStackView.isHidden = true
    }

    func exitEditingMode() {
        isEditingContent = false
        contentLabel.text = contentTextView.text
        contentTextView.resignFirstResponder()
        contentTextView.isEditable = false
        contentTextView.isHidden = true
        contentLabel.isHidden = false
        charCountLabel.isHidden = true
        dateLabel.isHidden = false
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = DSKitAsset.Colors.gray800.color
        confirmButton.setTitle("확인", for: .normal)
        editDeleteStackView.isHidden = false
        cancelEditButton.isHidden = true
        likeStackView.isHidden = false
    }

    func cancelEditingMode() {
        isEditingContent = false
        contentTextView.resignFirstResponder()
        contentTextView.isEditable = false
        contentTextView.isHidden = true
        contentLabel.isHidden = false
        charCountLabel.isHidden = true
        confirmButton.setTitle("확인", for: .normal)
        editDeleteStackView.isHidden = false
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = DSKitAsset.Colors.gray800.color
        cancelEditButton.isHidden = true
        likeStackView.isHidden = false
    }
}
