//
//  PokeOnboardingHorizontalStackView.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import Core
import Domain

public final class PokeOnboardingHorizontalStackView: UIView {
    
    // MARK: - Views
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0.f
        $0.alignment = .leading
        $0.distribution = .fillEqually
    }
    
    // MARK: - Variables
    private let pokeButtonClickSubject = PassthroughSubject<PokeUserModel, Error>()
    private let avatarClickSubject = PassthroughSubject<PokeUserModel, Error>()
    private var cancelBag = CancelBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initializeViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
extension PokeOnboardingHorizontalStackView {
    private func initializeViews() {
        self.addSubview(self.stackView)
    }
    
    private func setupConstraints() {
        self.stackView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
    }
}

// MARK: - internal methods
extension PokeOnboardingHorizontalStackView {
    func configure(with cellViewModels: [PokeUserModel]) {
        guard !cellViewModels.isEmpty else { return }
        
        guard cellViewModels.count < 3 else { return assertionFailure("1개 또는 2개 아이템만 넣을수 있어요") }
        
        cellViewModels.forEach { model in
            let cardView = PokeProfileCardView(frame: self.frame)

            cardView.setData(with: model)
            cardView
                .kokButtonTap
                .withUnretained(self)
                .sink(receiveValue: { _ in
                    self.pokeButtonClickSubject.send(model)
                }).store(in: self.cancelBag)
            
            cardView
                .profileTapped
                .withUnretained(self)
                .sink(receiveValue: { _ in
                    self.avatarClickSubject.send(model)
                }).store(in: self.cancelBag)
            
            self.stackView.addArrangedSubview(cardView)
        }
    }
    
    func signalForPokeButtonClick() -> AnyPublisher<PokeUserModel, Error> {
        return self.pokeButtonClickSubject.eraseToAnyPublisher()
    }
    
    func signalForAvatarClick() -> AnyPublisher<PokeUserModel, Error> {
        return self.avatarClickSubject.eraseToAnyPublisher()
    }
}
