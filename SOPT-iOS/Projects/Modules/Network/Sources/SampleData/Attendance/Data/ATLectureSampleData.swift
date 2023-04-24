//
//  AttendanceMockData+.swift
//  Network
//
//  Created by 김영인 on 2023/04/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

enum SampleData {
    enum Lecture {
        static let noSession = Data(
        """
        {
          "success": true,
          "message": "세미나가 없는 날입니다",
            "data": {
                "type": "NO_SESSION",
                "id": 0,
                "location": "",
                "name":"",
                "startDate": "",
                "endDate": "",
                "message":"",
                "attendances": []
            }
        }
        """.utf8
        )
        
        static let beforeAttendance = Data(
        """
        {
          "success": true,
          "message": "세미나 조회 성공",
          "data": {
                "type": "HAS_ATTENDANCE",
                "id": 1,
                "location": "건국대학교 경영관",
                "name":"2차 세미나",
                "startDate": "2023-04-06T14:13:51",
                "endDate": "2023-04-06T18:13:51",
                "message": "",
                "attendances": []
            }
        }
        """.utf8
        )
        
        static let firstAbsentCaseOne = Data(
        """
        {
          "success": true,
          "message": "세미나 조회 성공",
          "data": {
                "type": "HAS_ATTENDANCE",
                "id": 1,
                "location": "건국대학교 경영관",
                "name":"2차 세미나",
                "startDate": "2023-04-06T14:13:51",
                "endDate": "2023-04-06T18:13:51",
                "message": "",
                "attendances": [
                    {
                        "status": "ABSENT",
                      "attendedAt": "2023-04-07T14:12:09"
                    }
                ]
            }
        }
        """.utf8
        )
        
        static let firstAttendanceCaseOne = Data(
        """
        {
          "success": true,
          "message": "세미나 조회 성공",
          "data": {
                "type": "HAS_ATTENDANCE",
                "id": 1,
                "location": "건국대학교 경영관",
                "name":"2차 세미나",
                "startDate": "2023-04-06T14:13:51",
                "endDate": "2023-04-06T18:13:51",
                "message": "",
                "attendances": [
                    {
                        "status": "ATTENDANCE",
                      "attendedAt": "2023-04-07T14:12:09"
                    }
                ]
            }
        }
        """.utf8
        )
        
        static let absentCaseOne = Data(
        """
        {
          "success": true,
          "message": "세미나 조회 성공",
          "data": {
                "type": "HAS_ATTENDANCE",
                "id": 1,
                "location": "건국대학교 경영관",
                "name":"2차 세미나",
                "startDate": "2023-04-06T14:13:51",
                "endDate": "2023-04-06T18:13:51",
                "message": "",
                "attendances": [
                    {
                        "status": "ABSENT",
                      "attendedAt": "2023-04-07T14:12:09"
                    },
                    {
                        "status": "ABSENT",
                      "attendedAt": "2023-04-07T16:12:09"
                    },
                ]
            }
        }
        """.utf8
        )
        
        static let absenctCaseTwo = Data(
        """
        {
          "success": true,
          "message": "세션 조회 성공",
          "data": {
            "type": "HAS_ATTENDANCE",
                "id": 1,
            "location": "아름교육관",
            "name": "서버 1차 세미나",
            "startDate": "2023-04-13T14:00:00",
            "endDate": "2023-04-13T18:00:00",
            "message": "",
            "attendances": [
              {
                "status": "ATTENDANCE",
                "attendedAt": "2023-04-13T14:12:09"
              },
              {
                "status": "ABSENT",
                "attendedAt": "2023-04-13T14:10:04"
              }
            ]
          }
        }
        """.utf8
        )
        
        static let tardy = Data(
        """
        {
          "success": true,
          "message": "세션 조회 성공",
          "data": {
            "type": "HAS_ATTENDANCE",
                "id": 1,
            "location": "아름교육관",
            "name": "서버 1차 세미나",
            "startDate": "2023-04-13T14:00:00",
            "endDate": "2023-04-13T18:00:00",
            "message": "",
            "attendances": [
              {
                "status": "ABSENT",
                "attendedAt": "2023-04-13T14:12:09"
              },
              {
                "status": "ATTENDANCE",
                "attendedAt": "2023-04-13T14:10:04"
              }
            ]
          }
        }
        """.utf8
        )
        
        static let attendanceComplete = Data(
        """
        {
          "success": true,
          "message": "세션 조회 성공",
          "data": {
            "type": "HAS_ATTENDANCE",
                "id": 1,
            "location": "아름교육관",
            "name": "서버 1차 세미나",
            "startDate": "2023-04-13T14:00:00",
            "endDate": "2023-04-13T18:00:00",
            "message": "",
            "attendances": [
              {
                "status": "ATTENDANCE",
                "attendedAt": "2023-04-13T14:12:09"
              },
              {
                "status": "ATTENDANCE",
                "attendedAt": "2023-04-13T17:00:04"
              }
            ]
          }
        }
        """.utf8
        )
        
        static let eventSession = Data(
        """
        {
          "success": true,
          "message": "세션 조회 성공",
          "data": {
            "type": "HAS_ATTENDANCE",
                "id": 12,
            "location": "방일초등학교",
            "name": "1차 행사",
            "startDate": "2023-04-13T14:04:56",
            "endDate": "2023-04-13T18:05:37",
            "message": "행사도 참여하고, 출석점수도 받고, 일석이조!",
            "attendances": [
              {
                "status": "ATTENDANCE",
                "attendedAt": "2023-04-13T17:10:46"
              },
              {
                "status": "ATTENDANCE",
                "attendedAt": "2023-04-13T14:10:20"
              }
            ]
          }
        }
        """.utf8
        )
        
        static let noAttendanceSession = Data(
        """
        {
          "success": true,
          "message": "세션 조회 성공",
          "data": {
            "type": "NO_ATTENDANCE",
                "id": 10,
            "location": "서울역 허브",
            "name": "솝커톤",
            "startDate": "2023-04-13T18:02:26",
            "endDate": "2023-05-16T16:02:00",
            "message": "출석 점수가 반영되지 않아요.",
            "attendances": []
          }
        }
        """.utf8
        )
    }
}
