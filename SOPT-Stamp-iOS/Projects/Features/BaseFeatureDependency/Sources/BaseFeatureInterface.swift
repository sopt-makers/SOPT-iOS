//
//  BaseFeatureInterface.swift
//  BaseFeatureDependency
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

public protocol BaseFeatureInterface {
    var viewController: UIViewController { get }
}

public extension BaseFeatureInterface where Self: UIViewController {
    var viewController: UIViewController {
        return self
    }
}
