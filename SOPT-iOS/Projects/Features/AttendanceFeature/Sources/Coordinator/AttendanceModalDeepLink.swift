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

public struct AttendanceModalDeepLink: DeepLinkExecutable {
    public let name = "attendance-modal"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? AttendanceCoordinator else { return nil }
        
        guard let subLectureIdValue = queryItems?.getQueryValue(key: "subLectureId"),
              let roundValue = queryItems?.getQueryValue(key: "round"),
              let subLectureId = Int(subLectureIdValue),
              let round = Int(roundValue)
        else {
            return nil
        }
        
        let attendanceRoundModel = AttendanceRoundModel(subLectureId: subLectureId, round: round)
        
        coordinator.showAttendance(attendanceRoundModel, nil)
        
        return coordinator
    }
}
