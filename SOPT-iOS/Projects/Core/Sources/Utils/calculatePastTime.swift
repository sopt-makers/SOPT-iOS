//
//  calculatePastTime.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public func calculatePastTime(date: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {

  let minute = 60
  let hour = minute * 60
  let day = hour * 60
  let week = day * 7

  var message: String = ""

  let format = DateFormatter()
  format.dateFormat = dateFormat
  format.locale = Locale(identifier: "ko_KR")
  format.timeZone = TimeZone(identifier: "Asia/Seoul")

  guard let tempDate = format.date(from: date) else {return ""}

  let now = Date()
  let useTime = Int(now.timeIntervalSince(tempDate))

  let articleDate = format.string(from: tempDate)
  
  if useTime < minute {
    message = "방금 전"
  } else if useTime < hour {
    message = String(useTime/minute) + "분 전"
  } else if useTime < day {
    message = String(useTime/hour) + "시간 전"
  } else if useTime < week {
    message = String(useTime/day) + "일 전"
  } else if useTime < week * 4 {
    message = String(useTime/week) + "주 전"
  } else {
    let timeArray = articleDate.components(separatedBy: " ")
    let dateArray = timeArray[0].components(separatedBy: "-")
    message = dateArray[1] + "월 " + dateArray[2] + "일"
  }
  
  return message
}
