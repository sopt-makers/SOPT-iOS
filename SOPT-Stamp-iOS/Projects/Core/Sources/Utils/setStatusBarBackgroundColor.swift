//
//  setStatusBarBackgroundColor.swift
//  Core
//
//  Created by 양수빈 on 2022/11/30.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

extension UIViewController {
    public func setStatusBarBackgroundColor(_ color: UIColor?) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let statusBarManager = window?.windowScene?.statusBarManager
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.backgroundColor = color
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = color
        }
    }
}
