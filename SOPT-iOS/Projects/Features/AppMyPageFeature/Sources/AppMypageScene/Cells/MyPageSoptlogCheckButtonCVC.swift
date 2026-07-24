//
//  MyPageSoptlogCheckButtonCVC.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

final class MyPageSoptlogCheckButtonCVC: UICollectionViewCell {

    // MARK: - UI Components

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
    }

    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
}

// MARK: - UI & Layout

extension MyPageSoptlogCheckButtonCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 18
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = DSKitAsset.Colors.gray100.color.cgColor
    }

    private func setLayout() {
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MyPageSoptlogCheckButtonCVC {
    func configureCell(model: MyPageItem) {
        self.titleLabel.attributedText = model.title.applyMDSFont(
            mdsFont: .label3,
            color: DSKitAsset.Colors.gray100.color,
            alignment: .center
        )
    }
}
