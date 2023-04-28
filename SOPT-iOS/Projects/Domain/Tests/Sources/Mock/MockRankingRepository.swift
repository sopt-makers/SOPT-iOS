//
//  MockRankingRepository.swift
//  DomainTests
//
//  Created by Junho Lee on 2023/04/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import Core
import XCTest

@testable import Domain

final class MockRankingRepository: RankingRepositoryInterface {
    var fetchRankingListModelResponse: Result<[RankingModel], Error>!

    private(set) var cancelBag = CancelBag()

    func fetchRankingListModel() -> AnyPublisher<[RankingModel], Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            switch self.fetchRankingListModelResponse {
            case .success(let model):
                promise(.success(model))
            case .failure(let error):
                promise(.failure(error))
            case .none:
                XCTFail("Should Set fetchRankingModel")
            }
        }
        .eraseToAnyPublisher()
    }
}
