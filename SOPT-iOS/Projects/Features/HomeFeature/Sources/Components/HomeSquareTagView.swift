//
//  HomeSquareTagView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class HomeSquareTagView: UIView {

    // MARK: - UI Components

    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        $0.textAlignment = .center
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeSquareTagView {
    private func setUI() {
        self.layer.cornerRadius = 4.f
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
}

// MARK: - Methods

extension HomeSquareTagView {
    func setData(with text: String) {
        self.titleLabel.text = text
    }
    
    @discardableResult
    public func setTitle(with title: String) -> Self {
        self.titleLabel.text = title
        return self
    }
    
    @discardableResult
    public func setTitleColor(with color: UIColor) -> Self {
        self.titleLabel.textColor = color
        return self
    }
    
    @discardableResult
    public func setBackgroundColor(with color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
}

