//
//  ClapListModel.swift
//  Domain
//
//  Created by 성현주 on 10/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ClapListModel: Hashable {
    public let id = UUID()
    public let name: String
    public let subtitle: String
    public let clapCount: Int

    public init(name: String, subtitle: String, clapCount: Int) {
        self.name = name
        self.subtitle = subtitle
        self.clapCount = clapCount
    }
}
