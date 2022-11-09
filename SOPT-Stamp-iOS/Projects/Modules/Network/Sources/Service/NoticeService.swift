//
//  NoticeService.swift
//  Network
//
//  Created by Junho Lee on 2022/10/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultNoticeService = BaseService<NoticeAPI>

public protocol NoticeService {
    
}

extension DefaultNoticeService: NoticeService {
    
}
