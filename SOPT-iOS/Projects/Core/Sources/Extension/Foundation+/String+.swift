//
//  String+.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public extension String {
    
    /// String을 UIImage로 반환하는 메서드
    func makeImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
    
    /// 서버에서 들어온 Date String을 Date 타입으로 반환하는 메서드
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("toDate() convert error")
            return Date()
        }
    }
    
    /// serverTimeToString의 용도 정의
    enum TimeStringCase {
        case forNotification
        case forDefault
    }
    
    /// 서버에서 들어온 Date String을 UI에 적용 가능한 String 타입으로 반환하는 메서드
    func serverTimeToString(forUse: TimeStringCase) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd"
        
        let currentTime = Int(Date().timeIntervalSince1970)
        
        switch forUse {
        case .forNotification:
            let getTime = self.toDate().timeIntervalSince1970
            let displaySec = currentTime - Int(getTime)
            let displayMin = displaySec / 60
            let displayHour = displayMin / 60
            let displayDay = displayHour / 24
            
            if displayDay >= 1 {
                return "\(displayDay)일 전"
            } else if displayHour >= 1 {
                return "\(displayHour)시간 전"
            } else if displayMin >= 1 {
                return "\(displayMin)분 전"
            } else {
                return "방금"
            }
        case .forDefault:
            return dateFormatter.string(from: self.toDate())
        }
    }
    
    /// 맨 앞 문자열 가져오는 메서드
    func getFirst() -> String? {
        return map({String($0)}).first
    }
    
    /// 맨 뒤 문자열 가져오는 메서트
    func getLast() -> String? {
        return map({String($0)}).last
    }
}

public extension String {
    func isPercentEncoded() -> Bool {
        guard let decodedString = self.removingPercentEncoding,
              let decodedData = decodedString.data(using: .utf8)
        else { return false }
        
        let encodedData = self.data(using: .utf8)
        
        return encodedData != decodedData
    }
    
    func removePercentEncodingIfNeeded() -> String {
        func removePercentEncodingRecursively(with string: String, attempts: Int) -> String {
            guard attempts > 0 else { return string }

            let decodedString = string.removingPercentEncoding ?? string
            return decodedString.isPercentEncoded() ? removePercentEncodingRecursively(with: decodedString, attempts: attempts - 1) : decodedString
        }
        
        guard isPercentEncoded(),
              let decodedString = self.removingPercentEncoding
        else { return self }
        
        return removePercentEncodingRecursively(with: decodedString, attempts: 2)
    }
    
    /// 긴 문장을 두 줄로 나누어야 할 경우, 문자열의 중간 인덱스로부터 (문자열의 40%까지) 앞쪽 부분을 탐색해가며
    /// 가장 처음 발견되는 공백의 인덱스에 Space('\n')를 삽입함으로써
    /// 자연스럽게 문장이 나눠질 수 있도록 합니다.
    ///
    func setLineBreakAtMiddle() -> String {
        let middleIndex = self.index(self.startIndex, offsetBy: self.count / 2)
        // 문자열에서 40%에 해당하는 인덱스
        let minFrontIndex = self.index(self.startIndex, offsetBy: Int(Double(self.count) * 0.4))
        var spaceIndex = self[minFrontIndex...middleIndex].lastIndex(of: " ")
        
        // 앞쪽에 띄어쓰기가 없으면, 중간 인덱스 뒷쪽의 첫번째 인덱스
        if spaceIndex == nil {
            spaceIndex = self[middleIndex...endIndex].firstIndex(of: " ")
        }
        
        var result: String = ""
        
        // 띄어쓰기 지점을 찾아 줄바꿈하기
        if let spaceIndex = spaceIndex {
            let front = self[..<spaceIndex].trimmingCharacters(in: .whitespaces)
            let back = self[spaceIndex...].trimmingCharacters(in: .whitespaces)
            result = front + "\n" + back
        }
        
        return result
    }
}
