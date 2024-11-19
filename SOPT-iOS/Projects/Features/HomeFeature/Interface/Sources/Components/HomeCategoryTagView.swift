//
//  HomeCategoryTagView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final public class HomeCategoryTagView: UIView {
    
    // MARK: - UI Components

    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.SuitV1.extraBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.secondary.color
        $0.textAlignment = .center
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let hotIconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icHot.image
    }
        
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeCategoryTagView {
    private func setStackView() {
        self.contentStackView.addArrangedSubviews(
            titleLabel
        )
    }
    
    private func setLayout() {
        self.addSubview(self.contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hotIconImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
    }
}
    
// MARK: - Methods

extension HomeCategoryTagView {
    func setData(with text: String, isHotTag: Bool) {
        self.titleLabel.text = text
        if isHotTag {
            self.contentStackView.insertArrangedSubview(hotIconImageView, at: 0)
        }
        layoutIfNeeded()
    }
}
