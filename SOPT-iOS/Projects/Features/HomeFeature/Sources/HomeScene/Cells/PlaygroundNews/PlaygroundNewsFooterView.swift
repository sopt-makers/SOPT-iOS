//
//  PlaygroundNewsFooterView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 5/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class PlaygroundNewsFooterView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let morePostsButton = UIButton(configuration: .plain()).then {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DSKitAsset.Colors.gray900.color
        config.baseForegroundColor = DSKitAsset.Colors.gray400.color
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 0)
        config.titleAlignment = .leading
        
        var attributedTitle = AttributedString(I18N.Home.PlaygroundNews.morePosts)
        attributedTitle.font = DSKitFontFamily.Suit.medium.font(size: 13)
        config.attributedTitle = attributedTitle
        
        config.image = DSKitAsset.Assets.chevronRight.image.withTintColor(DSKitAsset.Colors.gray400.color, renderingMode: .alwaysTemplate)
        config.imagePlacement = .trailing
        
        $0.configuration = config
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension PlaygroundNewsFooterView {
    private func setLayout() {
        self.addSubview(morePostsButton)
        
        morePostsButton.snp.makeConstraints { make in
            make.width.equalTo(157)
            make.height.equalTo(36)
            make.center.equalToSuperview()
        }
    }
}
