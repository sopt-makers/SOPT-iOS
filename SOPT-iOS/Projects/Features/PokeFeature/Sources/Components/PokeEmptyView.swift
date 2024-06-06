//
//  PokeEmptyView.swift
//  PokeFeature
//
//  Created by sejin on 12/17/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core

public final class PokeEmptyView: UIView {
    
    // MARK: - UI Components
    
    private let emptyImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.pokeEmptyGraphic.image
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = UIFont.MDS.label4.font
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // MARK: - initialization
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(emptyImageView, descriptionLabel)
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(62)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension PokeEmptyView {
    @discardableResult
    public func setImage(with image: UIImage) -> Self {
        self.emptyImageView.image = image
        return self
    }
    
    @discardableResult
    public func setText(with text: String) -> Self {
        self.descriptionLabel.text = text
        return self
    }
}
