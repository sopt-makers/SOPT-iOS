//
//  MissionService.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultMissionService = BaseService<MissionAPI>

public protocol MissionService {
    
}

extension DefaultMissionService: MissionService {
    
}

