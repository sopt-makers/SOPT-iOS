//
//  ListDetailRepository.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain
import Networks

public class ListDetailRepository {

    private let stampService: StampService
    private let s3Service: S3Service
    private let mediaService: MediaService

    private let cancelBag = CancelBag()

    public init(
        stampService: StampService,
        s3Service: S3Service,
        mediaService: MediaService
    ) {
        self.stampService = stampService
        self.s3Service = s3Service
        self.mediaService = mediaService
    }
}

extension ListDetailRepository: ListDetailRepositoryInterface {
    public func fetchListDetail(isAppjam: Bool?, missionId: Int, username: String?) -> AnyPublisher<ListDetailModel, Error> {
        let username = username ?? UserDefaultKeyList.User.soptampName
        guard let username else {
            return Fail(error: NSError()).eraseToAnyPublisher()
        }
        if isAppjam == true {
            return stampService.fetchAppJamStampDetail(missionId: missionId, nickname: username)
                .map { $0.toDomain() }
                .eraseToAnyPublisher()
        }
        return stampService.fetchStampListDetail(missionId: missionId, username: username)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    public func getPresignedURL() -> AnyPublisher<PresignedUrlModel, Error> {
        return s3Service.getPresignedUrl()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    public func uploadMedia(imageData: Data, presignedUrl: String) -> AnyPublisher<Void, Error> {
        return mediaService.uploadMedia(imageData: imageData, to: presignedUrl)
            .eraseToAnyPublisher()
    }

    public func postStamp(isAppjam: Bool?, stampData: ListDetailRequestModel) -> AnyPublisher<ListDetailModel, Error> {
        return isAppjam == true ?
        stampService.postAppJamStamp(requestModel: stampData.toEntity())
            .map { $0.toDomain() }
            .eraseToAnyPublisher() :
        stampService.postStamp(requestModel: stampData.toEntity())
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    public func putStamp(stampData: ListDetailRequestModel) -> Driver<Int> {
        return stampService.putStamp(requestModel: stampData.toEntity())
            .map { $0.toDomain() }
            .asDriver()
    }

    public func deleteStamp(stampId: Int) -> Driver<Bool> {
        return stampService.deleteStamp(stampId: stampId)
            .map { $0 == 200 }
            .asDriver()
    }

    public func clap(stampId: Int, clapCount: Int) -> AnyPublisher<Result<ClapCountModel, Error>, Never> {
        return stampService.clap(stampId: stampId, clapCount: clapCount)
            .map{ .success($0.toDomain()) }
            .catch{ Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
    
    public func getClapList(stampId: Int, nickname: String) -> AnyPublisher<[ClapperModel], Error> {
        return stampService.getClapList(stampId: stampId, nickname: nickname)
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
