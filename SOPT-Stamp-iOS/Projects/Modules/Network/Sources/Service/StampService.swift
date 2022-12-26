//
//  StampService.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultStampService = BaseService<StampAPI>

public protocol StampService {
    func fetchStampListDetail(userId: Int, missionId: Int) -> AnyPublisher<ListDetailEntity, Error>
}

extension DefaultStampService: StampService {
    public func fetchStampListDetail(userId: Int, missionId: Int) -> AnyPublisher<ListDetailEntity, Error> {
        requestObjectInCombine(StampAPI.fetchStampListDetail(userId: userId, missionId: missionId))
    }
}
