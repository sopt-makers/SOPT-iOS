//
//  ListDetailRepository.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class ListDetailRepository {
    
    private let stampService: StampService
    private let cancelBag = CancelBag()

    public init(service: StampService) {
        self.stampService = service
    }
}

extension ListDetailRepository: ListDetailRepositoryInterface {
    public func fetchListDetail(missionId: Int) -> Driver<ListDetailModel> {
        // TODO: - userdefault에서 userId 연결
        let userId: Int = 7
        return stampService.fetchStampListDetail(userId: userId, missionId: missionId)
            .map { $0.toDomain() }
            .asDriver()
    }
    
    public func postStamp(missionId: Int, stampData: ListDetailRequestModel) -> Driver<ListDetailModel> {
        // TODO: - networkService.
        return makeMockListDetailEntity()
    }
    
    public func putStamp(missionId: Int, stampData: ListDetailRequestModel) -> Driver<[String : Int]> {
        // TODO: - networkService
        return Just(["stampId": 11])
            .setFailureType(to: Error.self)
            .asDriver()
    }
    
    public func deleteStamp(stampId: Int) -> Driver<Bool> {
        // TODO: - networkService
        return Just(Bool.random())
            .setFailureType(to: Error.self)
            .asDriver()
    }
}

extension ListDetailRepository {
    private func makeMockListDetailEntity() -> Driver<ListDetailModel> {
        let mockData = ListDetailEntity.init(
            createdAt: "2022-01-22",
            updatedAt: "2022-02-01",
            id: 1,
            contents: "안녕하세요",
            images: ["https://avatars.githubusercontent.com/u/81167570?v=4"],
            userID: 3,
            missionID: 2)
        let date = mockData.toDomain()
        return Just(date)
            .setFailureType(to: Error.self)
            .asDriver()
    }
}
