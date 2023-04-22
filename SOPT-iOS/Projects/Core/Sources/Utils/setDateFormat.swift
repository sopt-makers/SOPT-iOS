//
//  setDateFormat.swift
//  Core
//
//  Created by 김영인 on 2023/04/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

extension String {
    
    /**

      - Description:
          "yyyy-MM-dd'T'HH:mm:ss" 형태로 주어진 날짜를 원하는 format으로 변경하는 메서드

      - parameters:
        - dateString: 변경하고자 하는 dateformat을 입력합니다. ex. "HH:mm"
     
    */

    public func setDateFormat(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: self) else { return "00:00" }
        
        dateFormatter.dateFormat = dateString
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: date)
    }
}
