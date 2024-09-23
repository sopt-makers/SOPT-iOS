//
//  DailySoptuneRepositoyInterface.swift
//  Domain
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

public protocol DailySoptuneRepositoyInterface {
    func getTodaysFortuneCard() -> AnyPublisher<DailySoptuneCardModel, Error>
    func getFriendRandomUser() -> AnyPublisher<PokeFriendRandomUserModel, Error>
}
