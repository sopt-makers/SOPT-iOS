//
//  RankingSection.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

enum RankingSection: CaseIterable {
    case chart
    case list
    
    static func type(_ index: Int) -> RankingSection {
        return self.allCases[index]
    }
}
