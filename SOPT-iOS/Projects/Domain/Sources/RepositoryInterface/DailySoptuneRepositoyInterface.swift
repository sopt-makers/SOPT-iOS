//
//  DailySoptuneRepositoyInterface.swift
//  Domain
//
//  Created by 강윤서 on 9/27/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

public protocol DailySoptuneRepositoyInterface {
    func getDailySoptuneResult(date: String) -> AnyPublisher<DailySoptuneResultModel, Error>
}
