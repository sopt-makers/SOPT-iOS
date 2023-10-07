//
//  ATLectureRoundSampleData.swift
//  Network
//
//  Created by 김영인 on 2023/04/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

extension SampleData {
    
    enum LectureRound {
        static let firstAttendance = Data(
        """
        {
          "success": true,
          "message": "출석 차수 조회 성공",
          "data": {
            "id": 1,
            "round": 1
          }
        }
        """.utf8
        )
        
        static let secondAttendance = Data(
        """
        {
          "success": true,
          "message": "출석 차수 조회 성공",
          "data": {
            "id": 1,
            "round": 2
          }
        }
        """.utf8
        )
        
        static let beforeAttendance = Data(
        """
        {
          "success": false,
          "message": "[LectureException] : 출석 시작 전입니다",
          "data": null
        }
        """.utf8
        )
        
        static let beforeFirstAttendance = Data(
        """
        {
          "success": false,
          "message": "[LectureException] : 1차 출석 시작 전입니다",
          "data": null
        }
        """.utf8
        )
        
        static let beforeSecondAttendance = Data(
        """
        {
          "success": false,
          "message": "[LectureException] : 2차 출석 시작 전입니다",
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
        
        
        static let afterSecondAttendance = Data(
        """
        {
          "success": false,
          "message": "[LectureException] : 2차 출석이 이미 종료되었습니다.",
          "data": null
        }
        """.utf8
        )
    }
}
