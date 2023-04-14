//
//  AttendanceService.swift
//  Network
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultAttendanceService = BaseService<AttendanceAPI>

public protocol AttendanceService {
    
}

extension DefaultAttendanceService: AttendanceService {
    
}
