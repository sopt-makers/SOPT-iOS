//
//  MainUserInfoModel.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public struct UserMainInfoModel {
    public let status, name: String
    public let profileImage: String?
    public let historyList: [Int]
    public let attendanceScore: Float?
    public let announcement: String?
    public let responseMessage: String?
    
    public var userType: UserType {
        switch status {
        case "": // 플그 미등록인 경우
            return .unregisteredInactive
        case UserType.active.rawValue:
            return .active
        case UserType.inactive.rawValue:
            return .inactive
        default:
            return .visitor
        }
    }
    
    public init(status: String, name: String, profileImage: String?, historyList: [Int], attendanceScore: Float?, announcement: String?, responseMessage: String?) {
        self.status = status
        self.name = name
        self.profileImage = profileImage
        self.historyList = historyList
        self.attendanceScore = attendanceScore
        self.announcement = announcement
        self.responseMessage = responseMessage
    }
}
