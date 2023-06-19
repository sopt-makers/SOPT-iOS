//
//  AlertUtils.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Core

public enum AlertUtils {
    public
    static func presentAlertVC(
        type: AlertType,
        theme: AlertVC.AlertTheme = .main,
        title: String,
        description: String = "",
        customButtonTitle: String,
        customAction: (() -> Void)? = nil,
        animated: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        let alertVC = AlertVC(alertType: type, alertTheme: theme)
            .setTitle(title, description)
            .setCustomButtonTitle(customButtonTitle)
        alertVC.customAction = customAction
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        let vc = UIApplication.getMostTopViewController()!
        vc.present(alertVC, animated: animated, completion: completion)
    }
    
    public
    static func presentNetworkAlertVC(
        theme: AlertVC.AlertTheme = .main,
        animated: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        let alertVC = AlertVC(alertType: .networkErr, alertTheme: theme)
            .setTitle(I18N.Default.networkError, I18N.Default.networkErrorDescription)
            .viewController
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        let vc = UIApplication.getMostTopViewController()!
        vc.present(alertVC, animated: animated, completion: completion)
    }
}
