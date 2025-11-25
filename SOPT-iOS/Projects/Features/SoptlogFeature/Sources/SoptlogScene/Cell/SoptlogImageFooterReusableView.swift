//
//  SoptlogImageFooterReusableView.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogImageFooterReusableView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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

extension SoptlogImageFooterReusableView {
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setLayout() {
        addSubview(imageView)
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(75)
        }
    }
}

// MARK: - Configuration

extension SoptlogImageFooterReusableView {
    func configure(image: UIImage?) {
        imageView.image = image
    }
}
