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
    func fetchRankingList(userId: Int) -> AnyPublisher<[RankingEntity], Error>
    func editSentence(userId: Int, sentence: String) -> AnyPublisher<EditSentenceEntity, Error>
}

extension DefaultRankService: RankService {
    public func fetchRankingList(userId: Int) -> AnyPublisher<[RankingEntity], Error> {
        requestObjectInCombine(RankAPI.rank(userId: userId))
    }
    
    public func editSentence(userId: Int, sentence: String) -> AnyPublisher<EditSentenceEntity, Error> {
        requestObjectInCombine(RankAPI.editSentence(userId: userId, sentence: sentence))
    }
}
