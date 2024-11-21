//
//  HomeRoundTagView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class HomeRoundTagView: UIView {

    // MARK: - UI Components
    
    private let contentView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray700.color
    }
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        $0.textColor = DSKitAsset.Colors.gray100.color
        $0.textAlignment = .center
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
    }
}

// MARK: - UI & Layout

extension HomeRoundTagView {
    private func setLayout() {
        self.addSubview(self.contentView)
        contentView.addSubviews(titleLabel)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(5)
        }
    }
}

// MARK: - Methods

extension HomeRoundTagView {
    func setData(with text: String) {
        self.titleLabel.text = text
        self.layoutIfNeeded()
    }
}
