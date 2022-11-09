//
//  addSubviews.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
