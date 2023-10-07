//
//  MainUserInfoModel.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public struct UserMainInfoModel: Equatable {
    public let status, name: String
    public let profileImage: String?
    public let historyList: [Int]
    public let attendanceScore: Float?
    public let announcement: String?
    public let isAllConfirm: Bool?
    
    public var userType: UserType {
        switch status {
        case UserType.active.rawValue:
            return .active
        case UserType.inactive.rawValue:
            return .inactive
        default:
            return .visitor
        }
    }
    
    public init(status: String, name: String, profileImage: String?, historyList: [Int], attendanceScore: Float?, announcement: String?, isAllConfirm: Bool?) {
        self.status = status
        self.name = name
        self.profileImage = profileImage
        self.historyList = historyList
        self.attendanceScore = attendanceScore
        self.announcement = announcement
        self.isAllConfirm = isAllConfirm
    }
}
