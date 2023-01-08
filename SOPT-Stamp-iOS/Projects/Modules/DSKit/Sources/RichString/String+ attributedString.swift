//
//  String+ attributedString.swift
//  DSKitDemoApp
//
//  Created by Junho Lee on 2023/01/09.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public extension String {
    func zeroKernString() -> NSMutableAttributedString {
        let attributedStr = NSMutableAttributedString(string: self)
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
        return attributedStr
    }
}
