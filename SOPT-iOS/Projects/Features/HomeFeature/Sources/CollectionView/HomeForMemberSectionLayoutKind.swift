//
//  HomeForMemberSectionLayoutKind.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

enum HomeForMemberSectionLayoutKind: Int, CaseIterable {
    case mainService
    case appService
    case insight
    case group
    case coffeeChat
    case announcement
    case socialLinks
    
    static func type(_ index: Int) -> HomeForMemberSectionLayoutKind? {
        return self.allCases[safe: index]
    }
}
