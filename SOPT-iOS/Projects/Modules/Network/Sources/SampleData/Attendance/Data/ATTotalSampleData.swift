//
//  ATTotalSampleData.swift
//  Network
//
//  Created by 김영인 on 2023/04/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

extension SampleData {
    
    enum Total {
        static let success = Data(
        """
        {
          "success": true,
          "message": "전체 출석정보 조회 성공",
          "data": {
            "part": "SERVER",
            "generation": 32,
            "name": "용택",
            "score": 1.0,
            "total": {
              "attendance": 1,
              "absent": 1,
              "tardy": 1,
              "participate": 1
            },
            "attendances": [
              {
                "attribute": "ETC",
                "name": "솝커톤",
                "status": "PARTICIPATE",
                "date": "5월 16일"
              },
              {
                "attribute": "SEMINAR",
                "name": "서버 2차 세미나",
                "status": "ATTENDANCE",
                "date": "4월 14일"
              },
              {
                "attribute": "SEMINAR",
                "name": "서버 1차 세미나",
                "status": "ABSENT",
                "date": "4월 10일"
              },
              {
                "attribute": "SEMINAR",
                "name": "OT",
                "status": "TARDY",
                "date": "4월 2일"
              }
            ]
          }
        }
        """.utf8
        )
    }
}
