//
//  RankService.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultRankService = BaseService<RankAPI>

public protocol RankService {
    func fetchRankingList() -> AnyPublisher<[RankingEntity], Error>
    func fetchRankDetail(userName: String) -> AnyPublisher<RankDetailEntity, Error>
}

extension DefaultRankService: RankService {

    public func fetchRankingList() -> AnyPublisher<[RankingEntity], Error> {
        requestObjectInCombine(RankAPI.rank)
    }
    
    public func fetchRankDetail(userName: String) -> AnyPublisher<RankDetailEntity, Error> {
        requestObjectInCombine(RankAPI.rankDetail(userName: userName))
    }
}
