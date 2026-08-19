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
        title: String,
        description: String? = nil,
        checkBoxTitle: String? = nil,
        customAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let alertVC = AlertVC(type: type, title: title, description: description, checkBoxTitle: checkBoxTitle)
        alertVC.customAction = customAction
        alertVC.cancelAction = cancelAction
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        guard let vc = UIApplication.getMostTopViewController() else { return }
        vc.present(alertVC, animated: animated, completion: completion)
    }

    public
    static func presentNetworkAlertVC(
        confirmAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        presentAlertVC(
            type: .information(),
            title: I18N.Default.networkError,
            description: I18N.Default.networkErrorDescription,
            customAction: confirmAction,
            cancelAction: cancelAction,
            animated: animated,
            completion: completion
        )
    }
}
