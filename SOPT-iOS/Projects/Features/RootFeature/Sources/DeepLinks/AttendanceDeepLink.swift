//
//  AttendanceDeepLink.swift
//  RootFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import AttendanceFeature

public struct AttendanceDeepLink: DeepLinkExecutable {
    public let name = "attendance"
    public let children: [DeepLinkExecutable] = [AttendanceModalDeepLink()]
    public var isDestination: Bool = false
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
        
        let attendanceCoordinator = coordinator.runAttendanceFlow()
        return attendanceCoordinator
    }
}

