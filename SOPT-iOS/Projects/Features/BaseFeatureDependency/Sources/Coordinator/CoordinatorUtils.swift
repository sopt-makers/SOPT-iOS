//
//  CoordinatorUtils.swift
//  BaseFeatureDependency
//
//  Created by Jae Hyun Lee on 5/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

public enum CoordinatorUtils {
    /// 윈도우의 rootViewController를, 주입받은 viewController를 감싼 navigationController로 교체합니다.
    public static func replaceRootWindow(
        root navigation: UINavigationController,
        hideBar: Bool = false
    ) {
        guard let window = UIWindow.keyWindowGetter else { return }
        navigation.isNavigationBarHidden = hideBar
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    /// 윈도우의 rootViewController를 애니메이션과 함께 교체합니다.
    public static func replaceRootWindowWithAnimate(
        root navigation: UINavigationController,
        hideBar: Bool = false
    ) {
        guard let window = UIWindow.keyWindowGetter else { return }
        navigation.isNavigationBarHidden = hideBar
        
        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            navigation.view.addSubview(snapshot)
            window.rootViewController = navigation
            window.makeKeyAndVisible()

            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
    
    /// 최상위 navigationController에 화면을 push할 때 사용합니다.
    public static func pushOnRootNavigation(_ viewController: UIViewController, animated: Bool = true) {
        UIWindow.getRootNavigationController.pushViewController(viewController, animated: animated)
    }
}
