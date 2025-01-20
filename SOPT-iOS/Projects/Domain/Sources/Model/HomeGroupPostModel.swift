//
//  HomeGroupPostModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

public struct HomeGroupPostModel: Codable {
    public let id: Int
    public let title: String
    public let category: Category
    public let canJoinOnlyActiveGeneration: Bool
    public let joinableParts: [String]
    public let canJoinAllParts: Bool
    public let status: Status
    public let imageUrl: String
    
    public init(id: Int, title: String, category: Category, canJoinOnlyActiveGeneration: Bool, joinableParts: [String], canJoinAllParts: Bool, status: Status, imageUrl: String) {
        self.id = id
        self.title = title
        self.category = category
        self.canJoinOnlyActiveGeneration = canJoinOnlyActiveGeneration
        self.joinableParts = joinableParts
        self.canJoinAllParts = canJoinAllParts
        self.status = status
        self.imageUrl = imageUrl
    }
    
    // MARK: - Category Enum
    
    public enum Category: String, Codable {
        case event = "EVENT"
        case study = "STUDY"
        
        public var text: String {
            switch self {
            case .event:
                return "행사"
            case .study:
                return "스터디"
            }
        }
        
        public var textColor: UIColor {
            switch self {
            case .event:
                return DSKitAsset.Colors.success.color
            case .study:
                return DSKitAsset.Colors.secondary.color
            }
        }
    }
    
    // MARK: - Status Enum
    
    public enum Status: String, Codable {
        case beforeStart = "BEFORE_START"
        case applyAble = "APPLY_ABLE"
        case recruitmentComplete = "RECRUITMENT_COMPLETE"
        
        public var text: String {
            switch self {
            case .beforeStart:
                return I18N.Home.Group.beforeStart
            case .applyAble:
                return I18N.Home.Group.applyAble
            case .recruitmentComplete:
                return I18N.Home.Group.recruitmentComplete
            }
        }
        
        public var textColor: UIColor {
            switch self {
            case .beforeStart:
                return DSKitAsset.Colors.gray800.color
            case .applyAble:
                return DSKitAsset.Colors.gray800.color
            case .recruitmentComplete:
                return DSKitAsset.Colors.gray800.color
            }
        }
        
        public var backgroundColor: UIColor {
            switch self {
            case .beforeStart:
                return DSKitAsset.Colors.attention.color
            case .applyAble:
                return DSKitAsset.Colors.secondary.color
            case .recruitmentComplete:
                return DSKitAsset.Colors.gray100.color
            }
        }
    }
}
