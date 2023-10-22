//
//  DeepLinkView.swift
//  RootFeature
//
//  Created by sejin on 2023/10/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

struct DeepLinkViewKind: DeepLinkViewable {
    let name: String
    private let children: [DeepLinkViewable]
    
    func findChild(name: String) -> DeepLinkViewable? {
        for child in children {
            if child.name == name {
                return child
            }
        }
        
        return nil
    }
    
    static func findRoot(name: String) -> DeepLinkViewable? {
        // deepLink URL에서 첫 번째 인덱스가 "home"이 아닌 케이스가 생기면 여기서 분기 처리 하세요!
        if name == "home" {
            return DeepLinkViewKind.home
        }
        
        return nil
    }
}

extension DeepLinkViewKind: CustomStringConvertible {
    var description: String {
        return "\(self.name)"
    }
}

extension DeepLinkViewKind {
    static let home = DeepLinkViewKind(name: "home", children: [Home.notification, Home.mypage, Home.attendance, Home.soptamp])
    
    struct Home {
        static let notification = DeepLinkViewKind(name: "notification", children: [Notification.detail])
        static let mypage = DeepLinkViewKind(name: "mypage", children: [])
        static let attendance = DeepLinkViewKind(name: "attendance", children: [Attendance.attendanceModal])
        static let soptamp = DeepLinkViewKind(name: "soptamp", children: [Soptamp.entireRanking, Soptamp.currentGenerationRanking])
        
        struct Notification {
            static let detail = DeepLinkViewKind(name: "detail", children: [])
        }
        
        struct Attendance {
            static let attendanceModal = DeepLinkViewKind(name: "attendance-modal", children: [])
        }
        
        struct Soptamp {
            static let entireRanking = DeepLinkViewKind(name: "entire-ranking", children: [])
            static let currentGenerationRanking = DeepLinkViewKind(name: "current-generation-ranking", children: [])
        }
    }
}
