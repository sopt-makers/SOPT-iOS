//
//  ViewControllable.swift
//  BaseFeatureDependency
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

public protocol ViewControllable {
    var viewController: UIViewController { get }
    var asNavigationController: UINavigationController { get }
}
public extension ViewControllable where Self: UIViewController {
    var viewController: UIViewController {
        return self
    }
    
    var asNavigationController: UINavigationController {
        return self as? UINavigationController
        ?? UINavigationController(rootViewController: self)
    }
}

extension UIViewController: ViewControllable {}
