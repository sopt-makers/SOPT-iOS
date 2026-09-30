//
//  DefaultPostCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import Core
import DSKit
import MDS

enum PopularPostsCVCStatus {
    case focusing
    case unfocusing
}

enum PopularPostCategory: CaseIterable {
    case first
    case second
    case third
    
    var title: String {
        switch self {
        case .first:
            I18N.Home.PopularPosts.firstPost
        case .second:
            I18N.Home.PopularPosts.secondPost
        case .third:
            I18N.Home.PopularPosts.thirdPost
        }
    }
}

enum PostCellType {
    case popular
    case latest
    case empty
}

// 앰플리튜드 이벤트 트래킹을 위한 구조체입니다.
struct PostInfo {
    var postRanking: Int? = 0
    let sectionName: HomeAmplitudeEventPropertyValue
    var postID: Int? = 0
    let category: String
    let userID: Int?
}

final class DefaultPostCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    var onAnimationCompleted: (() -> Void)?
    private var isOutlineAnimationCancelled = false
    private var model: PostInfo?
    
    lazy var profileImageViewTap = profileImageView.gesture()
        .compactMap { [weak self] _ in self?.model }
        .asDriver()
    
    var cancelBag = CancelBag()
        
    // MARK: - UI & Layout

    private let categorySubPhraseView = HomeCategoryTagLabel().setTitleColor(SemanticColor.Fg.Brand.default)

    private let verticalDividerView = UIView().then {
        $0.backgroundColor = SemanticColor.Stroke.Neutral.default
    }
    
    private let categoryTagView = HomeCategoryTagLabel().setTitleColor(SemanticColor.Fg.Brand.default)
    
    private let profileImageView = MDSAvatar(size: 48, hasStroke: false)
    
    private let userNameLabel = UILabel().then {
        $0.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.bold, alignment: .center)
    }
    
    private let userPartLabel = UILabel().then {
        $0.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
    }
    
    private let userStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let postTitleLabel = UILabel().then {
        $0.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    private let postContentLabel = UILabel().then {
        $0.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
        $0.numberOfLines = 2
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }
    
    // 엠티 뷰일 경우
    private let emptyTitleLabel = UILabel().then {
        $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    private let emptySubLabel = UILabel().then {
        $0.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
    }
    
    private let emptyImageView = MDSAvatar(size: 48, hasStroke: false)

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setStackView()
        setLayout()
        setEmptyViewLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.numberOfLines = 1
        userNameLabel.lineBreakMode = .byTruncatingTail
        userNameLabel.text = nil
        userPartLabel.text = nil
        postTitleLabel.text = nil
        postContentLabel.text = nil
        emptySubLabel.text = nil
        emptyTitleLabel.text = nil
        emptyImageView.image = nil
        cancelBag = CancelBag()
        model = nil
        profileImageView.image = nil
        updateVisibility(for: .latest) // visible 상태는 기본적으로 latest와 같음
        self.cancelBag.cancel()
    }
}

// MARK: - UI & Layout

extension DefaultPostCVC {
    private func setUI() {
        self.backgroundColor = SemanticColor.Bg.Layer.default
        self.layer.cornerRadius = BaseRadius.Base.r12
    }

    private func setLayout() {
        self.addSubviews(userStackView, contentStackView)

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        userStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(userStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(22)
            make.top.equalToSuperview().inset(21)
        }
    }
    
    private func setStackView() {
        categoryStackView.addArrangedSubviews(
            categorySubPhraseView,
            verticalDividerView,
            categoryTagView
        )
        
        verticalDividerView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(7)
        }
        
        verticalDividerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        verticalDividerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        userStackView.addArrangedSubviews(
            profileImageView,
            userNameLabel,
            userPartLabel
        )
        
        userStackView.setCustomSpacing(5, after: profileImageView)
        userStackView.setCustomSpacing(1, after: userNameLabel)
        
        contentStackView.addArrangedSubviews(
            categoryStackView,
            postTitleLabel,
            postContentLabel
        )
    }
    
    // TODO: - 피그마 반영 후 수정 - 요청 상태
    /// Border가 있는 경우, gradient가 존재합니다.
    private func setGradientBorder() {
        let borderWidth: CGFloat = 1
        let cornerRadius: CGFloat = 12

        gradientLayer.frame = bounds

        let rect = bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.frame = bounds

        // 그라데이션 색상 설정
        gradientLayer.colors = [
            DSKitAsset.Colors.orange300.color.cgColor,
            DSKitAsset.Colors.orange200.color.cgColor,
            DSKitAsset.Colors.orange500.color.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.mask = shapeLayer
        gradientLayer.opacity = 0

        if gradientLayer.superlayer == nil {
            layer.addSublayer(gradientLayer)
        }
    }
    
    // 최신글이 없을 경우 띄워지는 엠티뷰입니다.
    private func setEmptyViewLayout() {
        self.addSubviews(emptySubLabel, emptyTitleLabel, emptyImageView)
        
        emptySubLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(38)
            make.leading.equalToSuperview().inset(28)
        }
        
        emptyTitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(38)
            make.leading.equalTo(emptySubLabel.snp.leading)
        }
        
        emptyImageView.snp.remakeConstraints { make in
            make.size.equalTo(64)
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
    
    private func changeTitleLabelColor(for target: String) {
        self.emptyTitleLabel.partColorChange(
            targetString: "[\(target)]",
            textColor: SemanticColor.Fg.Brand.default
        )
    }
    
    private func updateVisibility(for cellType: PostCellType) {
        switch cellType {
        case .popular, .latest:
            self.userStackView.isHidden = false
            self.contentStackView.isHidden = false

            self.emptyTitleLabel.isHidden = true
            self.emptySubLabel.isHidden = true
            self.emptyImageView.isHidden = true
        case .empty:
            self.emptyTitleLabel.isHidden = false
            self.emptySubLabel.isHidden = false
            self.emptyImageView.isHidden = false
            
            self.userStackView.isHidden = true
            self.contentStackView.isHidden = true
        }
    }
}

// MARK: - Methods

extension DefaultPostCVC {
    func configureCell(model: some PostDisplayable, index: IndexPath, cellType: PostCellType) {
        // NOTE: 사용자의 이름 값이 존재하지 않을 경우, 엠티뷰 레이아웃이 그려집니다.
        if let name = model.name, !name.isEmpty {
            self.userNameLabel.text = name
            self.userNameLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.bold, alignment: .center)
            updateVisibility(for: cellType)
        } else {
            self.emptySubLabel.text = model.title
            self.emptySubLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
            self.emptyTitleLabel.text = "[\(model.category)]\(model.content)"
            self.emptyTitleLabel.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
            changeTitleLabelColor(for: model.category)
            updateVisibility(for: .empty)
            return
        }
        
        self.categoryTagView.setData(with: model.category)
            
        let part = model.generationAndPart
        if let part, !part.isEmpty {
            // 익명이 아닐 경우
            self.userPartLabel.isHidden = false
            self.userPartLabel.text = part
            self.userPartLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
            self.userNameLabel.numberOfLines = 1
            self.userNameLabel.lineBreakMode = .byTruncatingTail
        } else {
            // 익명일 경우
            self.userPartLabel.isHidden = true
            self.userNameLabel.numberOfLines = 2
            self.userNameLabel.lineBreakMode = .byWordWrapping
        }
        
        switch cellType {
        case .latest:
            self.categorySubPhraseView.setData(with: "NEW")
        case .popular:
            if let category = PopularPostCategory.allCases[safe: index.row] {
                self.categorySubPhraseView.setData(with: category.title)
            }
        default: return
        }
        
        if let profileImage = model.profileImage {
            self.profileImageView.setImage(with: profileImage)
        }
        self.postTitleLabel.text = model.title
        self.postTitleLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)
        // content가 줄바꿈으로 시작하는 경우 방지
        self.postContentLabel.text = model.content.trimmingCharacters(in: .whitespacesAndNewlines)
        self.postContentLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)
    }
    
    // 앰플리튜드 이벤트 트래킹을 위해 세팅합니다.
    func setPostInfo(model: some PostDisplayable, section: HomeAmplitudeEventPropertyValue) {
        self.model = PostInfo(
            postRanking: model.ranking,
            sectionName: section,
            postID: model.postID,
            category: model.category,
            userID: model.userID
        )
    }
}


// MARK: - Animation Methods

extension DefaultPostCVC {
    /// 애니메이션 중단 메서드
    func cancelOutlineAnimation() {
        isOutlineAnimationCancelled = true
        gradientLayer.removeAllAnimations()
        gradientLayer.opacity = 0
        onAnimationCompleted = nil
    }
    
    /// 0.3초간 show -> 2.4초 기다림 -> 0.3초간 hide
    func setOutlinedAnimated() {
        isOutlineAnimationCancelled = false
        let interval = 2.4
        animateBorderOpacity(to: 1) { [weak self] in
            guard let self = self, !self.isOutlineAnimationCancelled else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                guard !self.isOutlineAnimationCancelled else { return }
                self.animateBorderOpacity(to: 0) { [weak self] in
                    guard let self = self, !self.isOutlineAnimationCancelled else { return }
                    self.onAnimationCompleted?()
                    cancelOutlineAnimation()
                }
            }
        }
    }

    private func animateBorderOpacity(to value: Float, completion: @escaping () -> Void) {
        guard !isOutlineAnimationCancelled else { return }
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = gradientLayer.presentation()?.opacity ?? gradientLayer.opacity
        animation.toValue = value
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if !self.isOutlineAnimationCancelled {
                completion()
            }
        }
        gradientLayer.add(animation, forKey: "opacity")
        gradientLayer.opacity = value
        CATransaction.commit()
    }
}
