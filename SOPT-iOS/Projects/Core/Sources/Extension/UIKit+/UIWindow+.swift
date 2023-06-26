//
//  UIWindow+.swift
//  Core
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

public extension UIWindow {
    static var keyWindowGetter: UIWindow? {
        if #available(iOS 13, *) {
            return (UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .flatMap { $0.windows }
                        .first { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    static var getRootNavigationController: UINavigationController {
        return keyWindowGetter?.rootViewController as? UINavigationController ?? UINavigationController(
            rootViewController: UIViewController()
        )
    }
}
