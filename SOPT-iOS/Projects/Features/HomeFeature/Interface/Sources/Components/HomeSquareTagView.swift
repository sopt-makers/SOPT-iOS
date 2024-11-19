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

final public class HomeSquareTagView: UIView {

    // MARK: - UI Components
    
    private let contentView = UIView().then {
        $0.layer.cornerRadius = 4.f
    }
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        $0.textAlignment = .center
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeSquareTagView {
    private func setLayout() {
        self.addSubview(self.contentView)
        contentView.addSubviews(titleLabel)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
}

// MARK: - Methods

extension HomeSquareTagView {
    func setData(with text: String) {
        self.titleLabel.text = text
        self.layoutIfNeeded()
    }
    
    @discardableResult
    public func setTitleColor(with color: UIColor) -> Self {
        self.titleLabel.textColor = color
        return self
    }
    
    @discardableResult
    public func setBackgroundColor(with color: UIColor) -> Self {
        self.contentView.backgroundColor = color
        return self
    }
}

