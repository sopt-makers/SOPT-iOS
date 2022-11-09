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
    static func setRootViewController(window: UIWindow, viewController: UIViewController, withAnimation: Bool) {
        if !withAnimation {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return
        }

        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
}
