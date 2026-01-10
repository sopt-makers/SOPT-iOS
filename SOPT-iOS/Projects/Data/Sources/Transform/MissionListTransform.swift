//
//  MissionListTransform.swift
//  Data
//
//  Created by Junho Lee on 2022/12/20.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public extension MissionListEntity {
    func toDomain() -> [MissionListModel] {
        self.map {
            if let isComplete = $0.isCompleted {
                return .init(id: $0.id,
                             title: $0.title,
                             level: $0.level,
                             isCompleted: isComplete,
                             ownerName: $0.ownerName,
                             profileImage: $0.profileImage?.first)
            } else {
                return .init(id: $0.id,
                             title: $0.title,
                             level: $0.level,
                             isCompleted: $0.fetchTypeHandler!,
                             ownerName: $0.ownerName,
                             profileImage: $0.profileImage?.first)
            }
        }
    }
}

extension SoptampReportUrlEntity {
    func toDomain() -> SoptampReportUrlModel {
        return SoptampReportUrlModel(reportUrl: reportUrl)
    }
}
