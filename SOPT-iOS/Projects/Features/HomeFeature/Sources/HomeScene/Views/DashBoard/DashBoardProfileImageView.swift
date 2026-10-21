//
//  DashBoardProfileImageView.swift
//  HomeFeature
//
//  Created by 최주리 on 12/10/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import MDS

final class DashBoardProfileImageView: UIView {
    
    // MARK: - UI Components
    
    private let profileImageView = MDSAvatar(size: 56, hasStroke: false)
    
    private let editBackgroundView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.default
        $0.layer.borderColor = SemanticColor.Stroke.Neutral.ghost.cgColor
        $0.layer.borderWidth = 2
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
    }
    
    private let editImageView = UIImageView().then {
        $0.image = MDSIcon.writeOutlined.image.withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension DashBoardProfileImageView {
    private func setLayout() {
        self.addSubviews(profileImageView, editBackgroundView)
        editBackgroundView.addSubview(editImageView)
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        editBackgroundView.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(-2)
            $0.trailing.equalTo(profileImageView.snp.trailing).offset(2)
        }
        
        editImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(8)
        }
    }
}

// MARK: - Methods

extension DashBoardProfileImageView {
    func configure(profileImageURL: String?) {
        guard let profileImageURL else { return }
        profileImageView.setImage(with: profileImageURL)
    }
}
