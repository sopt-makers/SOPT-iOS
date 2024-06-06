//
//  PokeMainSectionHeaderView.swift
//  PokeFeature
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit
import Core

public final class PokeMainSectionHeaderView: UIView {
    
    // MARK: - Properties
    
    public lazy var rightButtonTap: Driver<Void> = rightButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.MDS.title6.font
        $0.textColor = DSKitAsset.Colors.gray30.color
    }
    
    private let rightButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.btnArrowRight.image.withTintColor(DSKitAsset.Colors.gray300.color),
                    for: .normal)
    }
    
    // MARK: - initialization
    
    init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokeMainSectionHeaderView {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray900.color
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 12
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel, rightButton)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
        }
    }
}
