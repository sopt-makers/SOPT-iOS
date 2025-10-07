//
//  setRootViewController.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import UIKit

/**

  - Description:
 
          RootViewController를 만들어주는 유틸입니다. SnapShot을 찍어서 전환합니다.
          
*/
public enum ViewControllerUtils {
    /// viewController를 윈도우의 rootVC로 지정, snapshot으로 화면전환 시 사용
    public
    static func setRootViewController(window: UIWindow,
                                      viewController: UIViewController,
                                      withAnimation: Bool,
                                      completion: ((UIWindow) -> Void)? = nil) {
        if !withAnimation {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            completion?(window)
            return
        }

        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            completion?(window)
            
            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
    
    /// 기존 navigationController 유지, snapshot으로 화면전환 시 사용
    public
    static func setRootNavigationController(window: UIWindow,
                                            navigationController: UINavigationController,
                                            withAnimation: Bool,
                                            completion: ((UIWindow) -> Void)? = nil) {
        if !withAnimation {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            completion?(window)
            return
        }

        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            navigationController.view.addSubview(snapshot)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            completion?(window)
            
            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
}
