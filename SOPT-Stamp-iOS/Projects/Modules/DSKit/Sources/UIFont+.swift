//
//  UIFont+.swift
//  DSKit
//
//  Created by 양수빈 on 2022/10/13.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

extension UIFont {
    @nonobjc public class var h1: UIFont {
        return DSKitFontFamily.Pretendard.bold.font(size: 20)
    }
    
    @nonobjc public class var h2: UIFont {
        return DSKitFontFamily.Pretendard.bold.font(size: 18)
    }
    
    @nonobjc public class var h3: UIFont {
        return DSKitFontFamily.Pretendard.bold.font(size: 16)
    }
    
    @nonobjc public class var subtitle1: UIFont {
        return DSKitFontFamily.Pretendard.medium.font(size: 16)
    }
    
    @nonobjc public class var subtitle2: UIFont {
        return DSKitFontFamily.Pretendard.regular.font(size: 16)
    }
    
    @nonobjc public class var subtitle3: UIFont {
        return DSKitFontFamily.Pretendard.medium.font(size: 14)
    }
    
    @nonobjc public class var caption1: UIFont {
        return DSKitFontFamily.Pretendard.regular.font(size: 14)
    }
    
    @nonobjc public class var caption2: UIFont {
        return DSKitFontFamily.Pretendard.medium.font(size: 12)
    }
    
    @nonobjc public class var caption3: UIFont {
        return DSKitFontFamily.Pretendard.regular.font(size: 12)
    }
    
    @nonobjc public class var id: UIFont {
        return DSKitFontFamily.Montserrat.regular.font(size: 12)
    }
    
    @nonobjc public class var number1: UIFont {
        return DSKitFontFamily.Montserrat.bold.font(size: 24)
    }
    
    @nonobjc public class var number2: UIFont {
        return DSKitFontFamily.Montserrat.regular.font(size: 30)
    }
}
