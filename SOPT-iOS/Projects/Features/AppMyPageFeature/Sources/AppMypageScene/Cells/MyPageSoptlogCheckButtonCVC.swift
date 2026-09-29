//
//  MyPageSoptlogCheckButtonCVC.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Then

import MDS

final class MyPageSoptlogCheckButtonCVC: UICollectionViewCell {

    // MARK: - UI Components

    private let button = MDSActionButton(variant: .secondary, size: .small).then {
        $0.isUserInteractionEnabled = false
    }

    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.button.title = nil
    }
}

// MARK: - UI & Layout

extension MyPageSoptlogCheckButtonCVC {
    private func setLayout() {
        contentView.addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MyPageSoptlogCheckButtonCVC {
    func configureCell(model: MyPageItem) {
        button.title = model.title
    }
}
