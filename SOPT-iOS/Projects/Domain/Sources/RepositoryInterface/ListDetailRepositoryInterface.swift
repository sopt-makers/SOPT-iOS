//
//  ListDetailRepositoryInterface.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Core

import Combine
import Foundation

public protocol ListDetailRepositoryInterface {
    func fetchListDetail(isAppjam: Bool?, missionId: Int, username: String?) -> AnyPublisher<ListDetailModel, Error>
    func getPresignedURL() -> AnyPublisher<PresignedUrlModel, Error>
    func uploadMedia(imageData: Data, presignedUrl: String) -> AnyPublisher<Void, Error>
    func postStamp(isAppjam: Bool?, stampData: ListDetailRequestModel) -> AnyPublisher<ListDetailModel, Error>
    func putStamp(stampData: ListDetailRequestModel) -> Driver<Int>
    func deleteStamp(stampId: Int) -> Driver<Bool>
    func clap(stampId: Int, clapCount: Int) -> AnyPublisher<Result<ClapCountModel, Error>, Never>
    func getClapList(stampId: Int, nickname: String) -> AnyPublisher<[ClapperModel], Error>
    func postAppjamStamp(isAppjam: Bool?, stampData: ListDetailRequestModel) -> AnyPublisher<ListDetailModel, Error>
}
