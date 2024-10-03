//
//  setDateFormat.swift
//  Core
//
//  Created by 김영인 on 2023/04/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation


/**

  - Description:
      주어진 날짜를 원하는 format으로 변경하는 메서드
      주어진 날짜가 없는 경우 오늘 날짜 반환

  - parameters:
    - dateString: 변경하고자 하는 dateformat을 입력합니다. ex. "HH:mm"
 
*/

public func setDateFormat(date: String? = nil, from before: String? = nil, to after: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

    if let dateString = date,
        let before {
        
        dateFormatter.dateFormat = before
        guard let date = dateFormatter.date(from: dateString) else { return "00:00" }
        dateFormatter.dateFormat = after
        
        return dateFormatter.string(from: date)
    } else {
        dateFormatter.dateFormat = after
        return dateFormatter.string(from: Date())
    }
}
