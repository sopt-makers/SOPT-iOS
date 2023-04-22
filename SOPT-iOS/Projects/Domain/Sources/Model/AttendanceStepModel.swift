//
//  AttendanceStepModel.swift
//  Domain
//
//  Created by 김영인 on 2023/04/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public struct AttendanceStepModel {
    public let type: AttendanceStepType
    public let title: String?
    
    public init(type: AttendanceStepType, title: String?) {
        self.type = type
        self.title = title
    }
}
