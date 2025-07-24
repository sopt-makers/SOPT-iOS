//
//  AttendanceModalDeepLink.swift
//  AttendanceFeature
//
//  Created by sejin on 2023/11/09.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Domain

// TODO: - Legacy 삭제하면서 Core 제거
import Core

public struct AttendanceModalDeepLink: DeepLinkExecutable {
    public let name = "attendance-modal"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let subLectureIdValue = queryItems?.getQueryValue(key: "subLectureId"),
              let roundValue = queryItems?.getQueryValue(key: "round"),
              let subLectureId = Int(subLectureIdValue),
              let round = Int(roundValue)
        else {
            return nil
        }
        
        let attendanceRoundModel = AttendanceRoundModel(subLectureId: subLectureId, round: round)
        
        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyAttendanceCoordinator else { return nil }
            coordinator.showAttendance(attendanceRoundModel, nil)
        case .new:
            guard let coordinator = coordinator as? AttendanceCoordinator else { return nil }
            coordinator.showAttendance(attendanceRoundModel, nil)
        }
        
        return coordinator
    }
}
