//
//  AlertService.swift
//  Network
//
//  Created by Junho Lee on 2022/10/16.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultAlertService = BaseService<AlertAPI>

public protocol AlertService {
    
}

extension DefaultAlertService: AlertService {
    
}
