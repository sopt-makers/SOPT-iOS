//

//  DailySoptuneRepositoryInterface.swift
//  Domain
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

public protocol DailySoptuneRepositoryInterface {
    func getDailySoptuneResult(date: String) -> AnyPublisher<DailySoptuneResultModel, Error>
    func getTodaysFortuneCard() -> AnyPublisher<DailySoptuneCardModel, Error>
    func getRandomUser() -> AnyPublisher<[PokeRandomUserInfoModel], Error>
    func poke(userId: Int, message: String, isAnonymous: Bool) -> AnyPublisher<PokeUserModel, PokeError>
}
