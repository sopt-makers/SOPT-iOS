//
//  UIStackView+.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public extension UIStackView {
     func addArrangedSubviews(_ views: UIView...) {
         for view in views {
             self.addArrangedSubview(view)
         }
     }
    
    func removeAllSubViews() {
      self.subviews.forEach {
        self.removeFromStackView($0)
      }
    }

    func removeFromStackView(_ view: UIView) {
      view.removeFromSuperview()
      self.removeArrangedSubview(view)
    }
}
