//
//  MainServiceHeaderView.swift
//  MainFeature
//
//  Created by sejin on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class MainServiceHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.headline1
        label.textColor = DSKitAsset.Colors.white100.color
        label.textAlignment = .left
        label.text = I18N.Main.MainService.memberGuide
        return label
    }()
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MainServiceHeaderView {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MainServiceHeaderView {
    func initCell(title: String) {
        self.titleLabel.text = title
    }
}

