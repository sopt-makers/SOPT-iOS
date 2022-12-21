//
//  MissionListTransform.swift
//  Data
//
//  Created by Junho Lee on 2022/12/20.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

public extension MissionListEntity {
    func toDomain() -> [MissionListModel] {
        return self.map { .init(id: $0.id,
                                title: $0.title,
                                level: $0.level,
                                isCompleted: $0.isCompleted) }
    }
}
