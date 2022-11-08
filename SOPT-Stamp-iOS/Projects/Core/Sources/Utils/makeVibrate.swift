//
//  makeVibrate.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import UIKit

/**

  - Description:
 
      VC나 View 내에서 해당 함수를 호출하면, 햅틱이 발생하는 메서드입니다.
      버튼을 누르거나 유저에게 특정 행동이 발생했다는 것을 알려주기 위해 다음과 같은 햅틱을 활용합니다.

  - parameters:
    - degree: 터치의 세기 정도를 정의합니다. 보통은 medium,light를 제일 많이 활용합니다?!
          따라서 파라미터 기본값을 . medium으로 정의했습니다.
 
*/

public extension UIViewController {
    
  func makeVibrate(degree: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
}

public extension UIView {
    
    func makeVibrate(degree: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
}

public extension ViewModelType {
    
    func makeVibrate(degree: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
}
