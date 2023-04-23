//
//  ATAttendSampleData.swift
//  Network
//
//  Created by 김영인 on 2023/04/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

extension SampleData {
    
    enum Attend {
        static let success = Data(
        """
        {
          "success": true,
          "message": "출석 성공",
          "data": {
            "subLectureId": 17
          }
        }
        """.utf8
        )
        
        static let notCorrect = Data(
        """
        {
          "success": false,
          "message": "[LectureException] : 코드가 일치하지 않아요!",
          "data": null
        }
        """.utf8
        )
        
        static let afterFirstAttendance = Data(
        """
        {
          "success": false,
          "message": "[LectureException] : 1차 출석이 이미 종료되었습니다.",
          "data": null
        }
        """.utf8
        )
    }
}
