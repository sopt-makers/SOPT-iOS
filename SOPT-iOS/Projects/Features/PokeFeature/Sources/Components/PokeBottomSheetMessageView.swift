//
//  PokeBottomSheetMessageView.swift
//  PokeFeature
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import Core
import MDS
import Domain

// MARK: - PokeBottomSheetMessageView
final public class PokeBottomSheetMessageView: UIView {
    private enum Metrics {
        static let containerLeadingTrailing = 20.f
        static let maximumContainerHeight = 50.f
        
        static let contentLeadingTrailing = 8.f
        static let contentTopBottom = 12.f
    }
    
    private enum Constant {
        static let contentClickedStateBackgroundColor = SemanticColor.Bg.Neutral.Ghost.hover
        static let contentNormalStateBackgroundColor = SemanticColor.Bg.Neutral.ghost
    }
    
    // MARK: - Private variables
    private let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0.f
        $0.layer.cornerRadius = 14.f
    }
    
    private lazy var longPressGestureRecognzier = UILongPressGestureRecognizer().then {
        $0.minimumPressDuration = TimeInterval(0.01)
        $0.delegate = self
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer().then {
        $0.delegate = self
    }

    private let contentView = UIView()
    private let leftTitleLabel = UILabel().then {
        $0.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold, alignment: .left)
        $0.numberOfLines = 1
    }
    
    // MARK: Combine
    // MARK: Local variables
    private var cancelBag = CancelBag()
    private var messageModel: PokeMessageModel?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = SemanticColor.Bg.Neutral.ghost
        
        self.initializeViews()
        self.setupConstraints()
        self.setupBackgroundColorwithTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokeBottomSheetMessageView {
    private func initializeViews() {
        self.addSubview(self.containerStackView)
        self.containerStackView.addSubview(self.contentView)
        self.contentView.addSubview(self.leftTitleLabel)
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Metrics.containerLeadingTrailing)
            $0.height.lessThanOrEqualTo(Metrics.maximumContainerHeight)
        }
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metrics.contentLeadingTrailing)
            $0.top.bottom.equalToSuperview().inset(Metrics.contentTopBottom)
        }
        leftTitleLabel.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
    }
}

// MARK: - Public functions
extension PokeBottomSheetMessageView {
    public func configure(with messageModel: PokeMessageModel) {
        self.messageModel = messageModel
        self.leftTitleLabel.text = messageModel.content
        self.leftTitleLabel.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold, alignment: .left)
    }
    
    public func signalForClick() ->Driver<PokeMessageModel> {
        return self.containerStackView
            .gesture(.tap())
            .withUnretained(self)
            .compactMap({ owner, _ in
                owner.messageModel
            }).asDriver()
    }
}

// MARK: - Private functions
extension PokeBottomSheetMessageView {
    private func setupBackgroundColorwithTapGesture() {
        self.gesture(.longPress(longPressGestureRecognzier))
            .receive(on: DispatchQueue.main)
            .throttle(for: 0.01, scheduler: DispatchQueue.main, latest: false)
            .withUnretained(self)
            .sink(receiveValue: { owner, tapGesture in
                switch tapGesture.get().state {
                case .began, .recognized, .changed:
                    owner.containerStackView.backgroundColor = Constant.contentClickedStateBackgroundColor
                case .ended, .cancelled, .failed:
                    owner.containerStackView.backgroundColor = Constant.contentNormalStateBackgroundColor
                case .possible:
                    UIView.animate(withDuration: 0.1) {
                        owner.containerStackView.backgroundColor = Constant.contentNormalStateBackgroundColor
                    }
                @unknown default: break
                }
            }).store(in: cancelBag)
    }
}

extension PokeBottomSheetMessageView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
