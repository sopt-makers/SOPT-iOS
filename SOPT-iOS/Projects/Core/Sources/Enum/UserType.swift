//
//  UserType.swift
//  Core
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum UserType: String {
    case visitor = "UNAUTHENTICATED" // 비회원
    case active = "ACTIVE" // 활동 회원
    case inactive = "INACTIVE" // 비활동 회원
    case unregisteredInactive = "UNREGISTERED" // 비활동 회원 + 플그 프로필 미등록
    
    public func makeDescription(recentHistory: Int) -> String {
        switch self {
        case .visitor:
            return I18N.Main.visitor
        case .active:
            return "\(recentHistory)\(I18N.Main.active)"
        case .inactive:
            return "\(recentHistory)\(I18N.Main.inactive)"
        case .unregisteredInactive:
            return I18N.Main.inactiveMember
        }
    }
}
