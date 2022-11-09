//
//  calculatePastTime.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public func calculatePastTime(date: String) -> String {
  
  let minute = 60
  let hour = minute * 60
  let day = hour * 60
  let week = day * 7
  
  var message: String = ""
  
  let UTCDate = Date()
  let formatter = DateFormatter()
  formatter.timeZone = TimeZone(secondsFromGMT: 32400)
  formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
  let defaultTimeZoneStr = formatter.string(from: UTCDate)
  
  let format = DateFormatter()
  format.dateFormat = "yyyy-MM-dd HH:mm:ss"
  format.locale = Locale(identifier: "ko_KR")
  
  guard let tempDate = format.date(from: date) else {return ""}
  let krTime = format.date(from: defaultTimeZoneStr)
  
  let articleDate = format.string(from: tempDate)
  var useTime = Int(krTime!.timeIntervalSince(tempDate))
  useTime = useTime - 32400
  
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
