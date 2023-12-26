//
//  ToastUtils.swift
//  BaseFeatureDependency
//
//  Created by sejin on 12/26/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Core
import DSKit

public enum ToastUtils {
    public
    static func showMDSToast(type: MDSToast.ToastType, text: String, actionButtonAction: (() -> Void)? = nil) {
        Toast.showMDSToast(type: type, text: text, actionButtonAction: actionButtonAction)
    }
}

public extension UIViewController {
    @available(*, deprecated, message: "Use ToastUtils's MDS toast")
    func showToast(message: String) {
        Toast.show(message: message, view: self.view, safeAreaBottomInset: self.safeAreaBottomInset())
    }
}
