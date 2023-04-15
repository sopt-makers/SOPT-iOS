//
//  MainModel.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct MainModel {
    public let status, name, profileImage: String
    public let historyList: [Int]
    public let attendanceScore: Float
    public let announcement: String
    public let responseMessage: String?
    
    public init(status: String, name: String, profileImage: String, historyList: [Int], attendanceScore: Float, announcement: String, responseMessage: String?) {
        self.status = status
        self.name = name
        self.profileImage = profileImage
        self.historyList = historyList
        self.attendanceScore = attendanceScore
        self.announcement = announcement
        self.responseMessage = responseMessage
    }
}
