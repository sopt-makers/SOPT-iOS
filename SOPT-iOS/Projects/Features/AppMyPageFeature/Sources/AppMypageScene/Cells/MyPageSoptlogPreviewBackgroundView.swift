//
//  MyPageSoptlogPreviewBackgroundView.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import MDS

final class MyPageSoptlogPreviewBackgroundView: UICollectionReusableView {

    // MARK: - UI Components

    private let backgroundView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Layer.default
        $0.layer.cornerRadius = BaseRadius.Base.r10
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyPageSoptlogPreviewBackgroundView {
    private func setLayout() {
        self.addSubviews(backgroundView)

        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
