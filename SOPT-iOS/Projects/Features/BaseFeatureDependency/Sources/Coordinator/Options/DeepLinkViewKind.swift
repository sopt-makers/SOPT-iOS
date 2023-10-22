//
//  DeepLinkView.swift
//  RootFeature
//
//  Created by sejin on 2023/10/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct DeepLinkViewKind {
    public let name: String
    private let children: [DeepLinkViewKind]
    
    public func findChild(name: String) -> DeepLinkViewKind? {
        for child in children {
            if child.name == name {
                return child
            }
        }
        
        return nil
    }
    
    public static func findRoot(name: String) -> DeepLinkViewKind? {
        // deepLink URL에서 첫 번째 인덱스가 "home"이 아닌 케이스가 생기면 여기서 분기 처리 하세요!
        if name == "home" {
            return DeepLinkViewKind.home
        }
        
        return nil
    }
}

extension DeepLinkViewKind: CustomStringConvertible, Equatable {
    public var description: String {
        return "\(self.name)"
    }
}

extension DeepLinkViewKind {
    public static let home = DeepLinkViewKind(name: "home", children: [Home.notification, Home.mypage, Home.attendance, Home.soptamp])
    
    public struct Home {
        public static let notification = DeepLinkViewKind(name: "notification", children: [Notification.detail])
        public static let mypage = DeepLinkViewKind(name: "mypage", children: [])
        public static let attendance = DeepLinkViewKind(name: "attendance", children: [Attendance.attendanceModal])
        public static let soptamp = DeepLinkViewKind(name: "soptamp", children: [Soptamp.entireRanking, Soptamp.currentGenerationRanking])
        
        public struct Notification {
            public static let detail = DeepLinkViewKind(name: "detail", children: [])
        }
        
        public struct Attendance {
            public static let attendanceModal = DeepLinkViewKind(name: "attendance-modal", children: [])
        }
        
        public struct Soptamp {
            public static let entireRanking = DeepLinkViewKind(name: "entire-ranking", children: [])
            public static let currentGenerationRanking = DeepLinkViewKind(name: "current-generation-ranking", children: [])
        }
    }
}
