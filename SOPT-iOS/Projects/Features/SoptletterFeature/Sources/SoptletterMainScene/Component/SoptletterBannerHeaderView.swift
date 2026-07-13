//
//  SoptletterBannerHeaderView.swift
//  SoptletterFeature
//
//  Created by dev on 7/13/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import SnapKit

final class SoptletterBannerHeaderView: UICollectionReusableView {
    
    static let identifier = "SoptletterBannerHeaderView"
    
    let bannerView = SoptletterCTABannerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerView.onTap = nil
    }
}
