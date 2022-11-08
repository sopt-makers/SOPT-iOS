//
//  getClassName.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

/**

  - Description:
 
          각 VC,TVC,CVC의 className을 String으로 가져올 수 있도록 연산 프로퍼티를 설정합니다.
          요 값들은 나중에 Identifier에 잘 써먹을 수 있습니다 ^__^
*/

extension NSObject {    
    public static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    public var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}
