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
    func setImage(with url: String) {
        self.setImage(with: url, placeholder: DSKitAsset.Assets.iconDefaultProfile.image)
    }
}
