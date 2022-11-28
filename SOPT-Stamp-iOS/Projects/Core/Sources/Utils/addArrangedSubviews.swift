//
//  addArrangedSubviews.swift
//  Core
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

extension UIStackView {
    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubviews($0) }
    }
}
