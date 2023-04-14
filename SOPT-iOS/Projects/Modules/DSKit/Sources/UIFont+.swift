//
//  UIFont+.swift
//  DSKit
//
//  Created by 양수빈 on 2022/10/13.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

extension UIFont {
    public struct SoptampFont {
        @nonobjc public static var h1: UIFont {
            return DSKitFontFamily.Pretendard.bold.font(size: 20)
        }
        
        @nonobjc public static var h2: UIFont {
            return DSKitFontFamily.Pretendard.bold.font(size: 18)
        }
        
        @nonobjc public static var h3: UIFont {
            return DSKitFontFamily.Pretendard.bold.font(size: 16)
        }
        
        @nonobjc public static var subtitle1: UIFont {
            return DSKitFontFamily.Pretendard.medium.font(size: 16)
        }
        
        @nonobjc public static var subtitle2: UIFont {
            return DSKitFontFamily.Pretendard.regular.font(size: 16)
        }
        
        @nonobjc public static var subtitle3: UIFont {
            return DSKitFontFamily.Pretendard.medium.font(size: 14)
        }
        
        @nonobjc public static var caption1: UIFont {
            return DSKitFontFamily.Pretendard.regular.font(size: 14)
        }
        
        @nonobjc public static var caption1D: UIFont {
            return DSKitFontFamily.Pretendard.medium.font(size: 14)
        }
        
        @nonobjc public static var caption2: UIFont {
            return DSKitFontFamily.Pretendard.medium.font(size: 12)
        }
        
        @nonobjc public static var caption2D: UIFont {
            return DSKitFontFamily.Pretendard.regular.font(size: 12)
        }
        
        @nonobjc public static var caption3: UIFont {
            return DSKitFontFamily.Pretendard.regular.font(size: 12)
        }
        
        @nonobjc public static var id: UIFont {
            return DSKitFontFamily.Montserrat.regular.font(size: 12)
        }
        
        @nonobjc public static var number1: UIFont {
            return DSKitFontFamily.Montserrat.bold.font(size: 24)
        }
        
        @nonobjc public static var number2: UIFont {
            return DSKitFontFamily.Montserrat.regular.font(size: 30)
        }
        
        @nonobjc public static var number3: UIFont {
            return DSKitFontFamily.Montserrat.medium.font(size: 10)
        }
    }
    
    public struct Main {
        @nonobjc public static var display1: UIFont {
            return DSKitFontFamily.Suit.bold.font(size: 24)
        }
        
        @nonobjc public static var display2: UIFont {
            return DSKitFontFamily.Suit.medium.font(size: 24)
        }
        
        @nonobjc public static var headline1: UIFont {
            return DSKitFontFamily.Suit.bold.font(size: 20)
        }
        
        @nonobjc public static var headline2: UIFont {
            return DSKitFontFamily.Suit.bold.font(size: 16)
        }
        
        @nonobjc public static var body1: UIFont {
            return DSKitFontFamily.Suit.medium.font(size: 16)
        }
        
        @nonobjc public static var body2: UIFont {
            return DSKitFontFamily.Suit.medium.font(size: 14)
        }
        
        @nonobjc public static var caption1: UIFont {
            return DSKitFontFamily.Suit.medium.font(size: 12)
        }
        
        @nonobjc public static var caption2: UIFont {
            return DSKitFontFamily.Suit.medium.font(size: 10)
        }
        
        @nonobjc public static var caption3: UIFont {
            return DSKitFontFamily.Suit.regular.font(size: 14)
        }
    }
}
