//
//  OnboardingDataModel.swift
//  Domain
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public struct OnboardingDataModel {
    public var image: UIImage
    public var title, caption: String
    
    public init(image: UIImage, title: String, caption: String) {
        self.image = image
        self.title = title
        self.caption = caption
    }
}
