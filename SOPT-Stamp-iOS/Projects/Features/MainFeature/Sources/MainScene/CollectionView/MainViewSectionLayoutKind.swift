//
//  MainViewSectionLayoutKind.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

enum MainViewSectionLayoutKind: Int, CaseIterable {
    case userHistory
    case mainService
    case otherService
    case appService
    
    static func type(_ index: Int) -> MainViewSectionLayoutKind {
        return self.allCases[index]
    }
}
