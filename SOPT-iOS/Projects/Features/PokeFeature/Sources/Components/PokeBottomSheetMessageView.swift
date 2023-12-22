//
//  PokeBottomSheetMessageView.swift
//  PokeFeature
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import Domain


// MARK: - PokeBottomSheetMessageView
final public class PokeBottomSheetMessageView: UIView {
    private enum Metrics {
        static let containerLeadingTrailing = 20.f
        static let containerHeight = 40.f
        
        static let contentLeadingTrailing = 8.f
        static let contentTopBottom = 12.f
    }
    
    private enum Constant {
        static let contentClickedStateBackgroundColor = DSKitAsset.Colors.gray700.color
        static let contentNormalStateBackgroundColor = DSKitAsset.Colors.gray800.color
    }
    
    // MARK: - Private variables
    private let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0.f
        $0.layer.cornerRadius = 14.f
    }

    private let contentView = UIView()
    private let leftTitleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    // MARK: Combine
    // MARK: Local variables
    private var cancelBag = CancelBag()
    private var messageModel: PokeMessageModel?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        
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
        self.containerStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Metrics.containerLeadingTrailing)
            $0.height.equalTo(Metrics.containerHeight)
        }
        self.contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metrics.contentLeadingTrailing)
            $0.top.bottom.equalToSuperview().inset(Metrics.contentTopBottom)
        }
        self.leftTitleLabel.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
    }
}

// MARK: - Public functions
extension PokeBottomSheetMessageView {
    public func configure(with messageModel: PokeMessageModel) {
        self.messageModel = messageModel
        self.leftTitleLabel.text = messageModel.content
    }
    
    public func signalForClick() ->Driver<PokeMessageModel> {
        return self.containerStackView
            .gesture(.tap())
            .compactMap { [weak self] _ in self?.messageModel }
            .asDriver()
    }
}

// MARK: - Private functions
extension PokeBottomSheetMessageView {
    private func setupBackgroundColorwithTapGesture() {
        let longPressGestureRecognzier = UILongPressGestureRecognizer().then {
            $0.minimumPressDuration = TimeInterval(0.01)
        }
        
        self.gesture(.longPress(longPressGestureRecognzier))
            .receive(on: DispatchQueue.main)
            .throttle(for: 0.01, scheduler: DispatchQueue.main, latest: false)
            .sink(receiveValue: { tapGesture in
                switch tapGesture.get().state {
                case .began, .recognized, .changed:
                    self.containerStackView.backgroundColor = Constant.contentClickedStateBackgroundColor
                case .ended, .cancelled, .failed:
                    self.containerStackView.backgroundColor = Constant.contentNormalStateBackgroundColor
                case .possible:
                    UIView.animate(withDuration: 0.1) { [weak self] in
                        self?.containerStackView.backgroundColor = Constant.contentNormalStateBackgroundColor
                    }
                @unknown default: break
                }
            }).store(in: self.cancelBag)
    }
}
