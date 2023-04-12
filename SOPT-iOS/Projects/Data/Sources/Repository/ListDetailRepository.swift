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
        return stampService.fetchStampListDetail(missionId: missionId)
            .map { $0.toDomain() }
            .asDriver()
    }
    
    public func postStamp(missionId: Int, stampData: [Any]) -> AnyPublisher<ListDetailModel, Error> {
        return stampService.postStamp(missionId: missionId, requestModel: stampData)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func putStamp(missionId: Int, stampData: [Any]) -> Driver<Int> {
        return stampService.putStamp(missionId: missionId, requestModel: stampData)
            .map { $0.toDomain() }
            .asDriver()
    }
    
    public func deleteStamp(stampId: Int) -> Driver<Bool> {
        return stampService.deleteStamp(stampId: stampId)
            .map { $0 == 200 }
            .asDriver()
    }
}
