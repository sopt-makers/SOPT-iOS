//
//  SoptletterBannerHeaderView.swift
//  SoptletterFeature
//
//  Created by dev on 7/13/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import SnapKit

import MDS

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
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(BaseSpacing.Base.s12)
        }
    }

    func configure(ctaText: String, isHidden: Bool, onTap: (() -> Void)?) {
        bannerView.configure(text: ctaText)
        bannerView.setCollapsed(isHidden)
        bannerView.onTap = onTap

        bannerView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(isHidden ? BaseSpacing.Base.s0 : BaseSpacing.Base.s12)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bannerView.onTap = nil
    }
}
