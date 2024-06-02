//
//  UIFont+.swift
//  DSKit
//
//  Created by 양수빈 on 2022/10/13.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

extension UIFont {
  public enum MDS {
    case heading1
    case heading1_5
    case heading2
    case heading3
    case heading4
    case heading5
    case heading6
    case heading7
    case title1
    case title2
    case title3
    case title4
    case title5
    case title6
    case title7
    case body1
    case body2
    case body2R
    case body3
    case body3R
    case body4
    case body4R
    case label1
    case label2
    case label3
    case label4
    case label5
    
    public var font: UIFont {
      switch self {
      case .heading1: 
        return DSKitFontFamily.Suit.bold.font(size: 48)
      case .heading1_5:
        return DSKitFontFamily.Suit.bold.font(size: 40)
      case .heading2:
        return DSKitFontFamily.Suit.bold.font(size: 32)
      case .heading3:
        return DSKitFontFamily.Suit.bold.font(size: 28)
      case .heading4:
        return DSKitFontFamily.Suit.bold.font(size: 24)
      case .heading5:
        return DSKitFontFamily.Suit.bold.font(size: 20)
      case .heading6:
        return DSKitFontFamily.Suit.bold.font(size: 18)
      case .heading7:
        return DSKitFontFamily.Suit.bold.font(size: 16)
      case .title1:
        return DSKitFontFamily.Suit.semiBold.font(size: 32)
      case .title2:
        return DSKitFontFamily.Suit.semiBold.font(size: 28)
      case .title3:
        return DSKitFontFamily.Suit.semiBold.font(size: 24)
      case .title4:
        return DSKitFontFamily.Suit.semiBold.font(size: 20)
      case .title5:
        return DSKitFontFamily.Suit.semiBold.font(size: 18)
      case .title6:
        return DSKitFontFamily.Suit.semiBold.font(size: 16)
      case .title7:
        return DSKitFontFamily.Suit.semiBold.font(size: 14)
      case .body1:
        return DSKitFontFamily.Suit.medium.font(size: 18)
      case .body2:
        return DSKitFontFamily.Suit.medium.font(size: 16)
      case .body2R:
        return DSKitFontFamily.Suit.regular.font(size: 16)
      case .body3:
        return DSKitFontFamily.Suit.medium.font(size: 14)
      case .body3R:
        return DSKitFontFamily.Suit.regular.font(size: 14)
      case .body4:
        return DSKitFontFamily.Suit.medium.font(size: 13)
      case .body4R:
        return DSKitFontFamily.Suit.regular.font(size: 13)
      case .label1:
        return DSKitFontFamily.Suit.semiBold.font(size: 18)
      case .label2:
        return DSKitFontFamily.Suit.semiBold.font(size: 16)
      case .label3:
        return DSKitFontFamily.Suit.semiBold.font(size: 14)
      case .label4:
        return DSKitFontFamily.Suit.semiBold.font(size: 12)
      case .label5:
        return DSKitFontFamily.Suit.semiBold.font(size: 11)
      }
    }
    
    public var lineHeight: CGFloat {
      switch self {
      case .heading1: 
        return 72.f
      case .heading1_5:
        return 72.f
      case .heading2:
        return 48.f
      case .heading3:
        return 42.f
      case .heading4:
        return 36.f
      case .heading5:
        return 30.f
      case .heading6:
        return 28.f
      case .heading7:
        return 24.f
      case .title1:
        return 48.f
      case .title2:
        return 42.f
      case .title3:
        return 36.f
      case .title4:
        return 30.f
      case .title5:
        return 28.f
      case .title6:
        return 24.f
      case .title7:
        return 20.f
      case .body1:
        return 30.f
      case .body2:
        return 26.f
      case .body2R:
        return 26.f
      case .body3:
        return 22.f
      case .body3R:
        return 22.f
      case .body4:
        return 20.f
      case .body4R:
        return 20.f
      case .label1:
        return 24.f
      case .label2:
        return 22.f
      case .label3:
        return 18.f
      case .label4:
        return 16.f
      case .label5:
        return 14.f
      }
    }
        
    // NOTE(승호): iOS의 kern은 절댓값이라서 값을 일일이 대조해야 해요.
    // https://www.figma.com/design/ZuAGH1zZDxduHsjCZm8kfH/makers-design-system?node-id=1108-449&t=MModRhfeVMnp4tml-4
    // MDS에서 관리하고 있는 Font의 letterSpacing은 비율으로 관리되고 있습니다, 따라서 이에 맞게 하나씩 대조해가며 양수 또는 음수로 처리해야 합니다.
    public var letterSpacing: CGFloat {
      switch self {
      case .heading1: return 0.f
      case .heading1_5: return 0.f
      case .heading2: return 0.f
      case .heading3: return 0.f
      case .heading4: return 0.f
      case .heading5: return 0.f
      case .heading6: return 0.f
      case .heading7: return 0.f
      case .title1: return 0.f
      case .title2: return 0.f
      case .title3: return 0.f
      case .title4: return 0.f
      case .title5: return 0.f
      case .title6: return 0.f
      case .title7: return 0.f
      case .body1: return 0.f
      case .body2: return 0.f
      case .body2R: return 0.f
      case .body3: return 0.f
      case .body3R: return 0.f
      case .body4: return 0.f
      case .body4R: return 0.f
      case .label1: return 0.f
      case .label2: return 0.f
      case .label3: return 0.f
      case .label4: return 0.f
      case .label5: return 0.f
      }
    }
  }
  
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
    
    @nonobjc public static var body0: UIFont {
      return DSKitFontFamily.Suit.medium.font(size: 18)
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
  
  public struct Attendance {
    @nonobjc public static var h1: UIFont {
      return DSKitFontFamily.Suit.bold.font(size: 18)
    }
    
    @nonobjc public static var h2: UIFont {
      return DSKitFontFamily.Suit.bold.font(size: 14)
    }
  }
}
