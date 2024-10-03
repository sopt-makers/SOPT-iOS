//
//  DailySoptuneProfileImageView.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 10/3/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import DSKit

extension CustomProfileImageView {
    public func setImage(with url: String) {
        self.setImage(with: url, placeholder: DSKitAsset.Assets.iconDefaultProfile.image)
    }
    
    // 오늘의 솝마디에서는 Border가 들어가지 않는 것으로 통일
    @discardableResult
    public func setBorder() -> Self {
        self.layer.borderWidth = 0
        return self
    }
}
