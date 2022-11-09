//
//  calculateTopInset.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import UIKit

/**
 - Description:
 
 상단의 탑 safe Area를 계산하는 함수입니다
 노치가 있는 경우에는 safe area inset 만큼 음수값을 주고,
 노치가 없는 경우에는 -44로 고정값을 부여합니다
 */

public extension UIViewController {
    func calculateTopInset() -> CGFloat {
        let windows = UIApplication.shared.windows[0]
        let topInset = windows.safeAreaInsets.top
        
        if UIDevice.current.hasNotch {
            return topInset * -1
        } else {
            return -44
        }
    }
    
    func safeAreaBottomInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding ??  0.0
        } else {
            return 0.0
        }
    }
}

/**
 
 - Description:
 
 해당 기기가, notch를 가지고 있는지 bottom safe area inset를 계산해서 판단하는 연산 프로퍼티입니다.
 
 */

public extension UIDevice {
    var hasNotch: Bool {
        UIScreen.main.bounds.height > 736 ? true : false
    }
}
