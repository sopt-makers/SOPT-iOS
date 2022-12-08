//
//  MissionListSection.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

enum MissionListSection: CaseIterable {
    case sentence
    case missionList
    
    static func type(_ index: Int) -> MissionListSection {
        return self.allCases[index]
    }
}
