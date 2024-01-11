//
//  PokeNotificationListContentView.swift
//  PokeFeature
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import DSKit

import UIKit
import Domain

final public class PokeNotificationListContentView: UIView, PokeCompatible {
    private enum Metrics {
        static let contentDefaultSpacing = 8.f
        static let leftToCenterContentPadding = 12.f
        static let profileAvatarLength = 50.f
        
        static let centerToRightContentPadding = 8.f
        static let centerTopContentPadding = 8.f
        
        static let centerSeperateContentsMinHeight = 22.f

        static let centerContentPaddingAfterDescription = 4.f
    }
    
    private enum Constant {
        static let numberOfLinesForDetailView = 2
        static let defaultNumberOfLines = 1
    }
    
    // MARK: - ContentStack
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = Metrics.contentDefaultSpacing
        $0.alignment = .center
    }
    
    // MARK: Left:
    private let profileImageView = PokeProfileImageView()

    // MARK: Center:
    private lazy var centerContentsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    private lazy var centerTopContentsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = Metrics.centerTopContentPadding
        $0.alignment = .center
    }
    
    // Center-Top
    private let nameLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.textAlignment = .left
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    private let partInfoLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.textAlignment = .left
    }
    
    // Center-middle
    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = self.isDetailView ? Constant.numberOfLinesForDetailView : Constant.defaultNumberOfLines
    }
    
    // Center-bottom
    private lazy var pokeChipView = PokeChipView(frame: self.frame)
    
    // MARK: Right:
    private let pokeKokButton = PokeKokButton()
    
    // NOTE: NotifcationDetailView에서는 description의 numberOfLine Value가 2에요
    private let isDetailView: Bool
    
    private var userId: Int?
    var user: PokeUserModel?
    
    lazy var kokButtonTap: Driver<PokeUserModel?> = pokeKokButton.tap
        .map { self.user }
        .asDriver()
    
    lazy var profileImageTap = profileImageView
        .tap
        .map { self.user }
    
    // MARK: - View Lifecycle
    public init(
        isDetailView: Bool = true,
        frame: CGRect
    ) {
        self.isDetailView = isDetailView
      
        super.init(frame: frame)

        self.initializeViews()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokeNotificationListContentView {
    private func initializeViews() {
        self.addSubview(self.contentStackView)
        
        self.contentStackView.addArrangedSubviews(
            self.profileImageView,
            self.centerContentsStackView,
            self.pokeKokButton
        )
        
        self.centerContentsStackView.addArrangedSubviews(
            self.centerTopContentsStackView,
            self.descriptionLabel,
            self.pokeChipView
        )
        
        self.centerTopContentsStackView.addArrangedSubviews(
            self.nameLabel,
            self.partInfoLabel
        )
        
        self.contentStackView.setCustomSpacing(
            Metrics.leftToCenterContentPadding,
            after: self.centerContentsStackView
        )
        
        self.centerContentsStackView.setCustomSpacing(
            Metrics.centerContentPaddingAfterDescription,
            after: self.descriptionLabel
        )
    }
    
    private func setupConstraint() {
        self.contentStackView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }

        self.centerTopContentsStackView.snp.makeConstraints { $0.height.equalTo(Metrics.centerSeperateContentsMinHeight) }
        self.descriptionLabel.snp.makeConstraints { $0.height.greaterThanOrEqualTo(Metrics.centerSeperateContentsMinHeight) }
        self.profileImageView.snp.makeConstraints { $0.size.equalTo(Metrics.profileAvatarLength) }
    }
}

extension PokeNotificationListContentView {
    public func configure(with model: PokeUserModel) {
        self.user = model
        self.userId = model.userId
        self.profileImageView.setImage(with: model.profileImage, relation: PokeRelation(rawValue: model.relationName) ?? .newFriend)
        self.nameLabel.text = model.name
        self.partInfoLabel.text = model.part
        self.descriptionLabel.attributedText = model.message.applyMDSFont()
        self.pokeChipView.configure(with: model.mutualRelationMessage)
        self.pokeKokButton.isEnabled = !model.isAlreadyPoke
    }
    
    func setData(with model: PokeUserModel) {
        self.configure(with: model)
    }
    
    func changeUIAfterPoke(newUserModel: PokeUserModel) {
        guard let user, user.userId == newUserModel.userId else { return }
        
        self.setData(with: newUserModel)
    }
    
    public func signalForPokeButtonClicked() -> Driver<PokeUserModel> {
        self.pokeKokButton
            .tap
            .compactMap { [weak self] _ in self?.user }
            .asDriver()
    }

}

// NOTE(@승호): MDSFont 적용하고 DSKit으로 옮기고 적용하기.
private extension String {
  func applyMDSFont() -> NSMutableAttributedString {
    self.applyMDSFont(
      height: 22.f,
      font: DSKitFontFamily.Suit.medium.font(size: 14),
      color: DSKitAsset.Colors.gray30.color,
      letterSpacing: 0.f
    )
  }
  
  func applyMDSFont(
    height: CGFloat,
    font: UIFont,
    color: UIColor,
    letterSpacing: CGFloat,
    alignment: NSTextAlignment = .left,
    lineBreakMode: NSLineBreakMode = .byTruncatingTail
  ) -> NSMutableAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = lineBreakMode
    paragraphStyle.minimumLineHeight = height
    paragraphStyle.alignment = alignment
    
    if lineBreakMode == .byWordWrapping {
      paragraphStyle.lineBreakStrategy = .hangulWordPriority
    }
    
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: color,
      .font: font,
      .kern: letterSpacing,
      .paragraphStyle: paragraphStyle,
      .baselineOffset: (paragraphStyle.minimumLineHeight - font.lineHeight) / 4
    ]
    
    let attrText = NSMutableAttributedString(string: self)
    attrText.addAttributes(attributes, range: NSRange(location: 0, length: self.utf16.count))
    return attrText
  }
}
