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
        DateFormatManager.shared.setFormat(.iso)
        if let date = DateFormatManager.shared.stringToDate(self) {
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
        DateFormatManager.shared.setFormat(.dateWithSlash)
        
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
            return DateFormatManager.shared.dateToString(self.toDate())
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
            spaceIndex = self[middleIndex..<endIndex].firstIndex(of: " ")
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
    
    /// 해당 폰트가 글자를 렌더링할 수 있는 글리프를 가지고 있는지 확인합니다.
    func canBeRendered(by font: UIFont) -> Bool {
        /// 해당 글자의 UIFont를 CTFont로 변환한다.
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        /// 해당 문자열을 UTF-16 코드우닛 배열로 변환한다.
        let utf16Chars = Array(self.utf16)
        /// 빈 문자열일 때는 검사할 것이 없으므로 가드 처리
        guard !utf16Chars.isEmpty else { return true }
        
        /// 각 UTF-16 코드유닛을 폰트의 cmap 배열에서 찾아 대응하는 글리프 ID를 배열에 채운다.
        var glyphs = [CGGlyph](repeating: 0, count: utf16Chars.count)
        guard CTFontGetGlyphsForCharacters(cfFont, utf16Chars, &glyphs, utf16Chars.count) else { return false }

        /// 매핑이 됐어도 실제로 그릴 내용이 있는 글리프인지 한번 더 검증한다.
        /// 실제 벡터path를 가져와 path가 비어있는지 값을 리턴한다.
        return glyphs.allSatisfy { glyph in
            guard glyph != 0,
                  let path = CTFontCreatePathForGlyph(cfFont, glyph, nil) else { return false }
            return !path.isEmpty
        }
    }
}
