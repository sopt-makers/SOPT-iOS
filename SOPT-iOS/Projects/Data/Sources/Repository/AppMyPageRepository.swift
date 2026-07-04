//
//  AppMyPageRepository.swift
//  Data
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

import SafariServices
import WebKit

public final class AppMyPageRepository {
    private let stampService: StampService
    private let userService: UserService

    public init(
        stampService: StampService,
        userService: UserService
    ) {
        self.stampService = stampService
        self.userService = userService
    }
}

extension AppMyPageRepository: AppMyPageRepositoryInterface {
    public func resetStamp() -> Driver<Bool> {
        self.stampService
            .resetStamp()
            .map { $0 == 200 }
            .asDriver()
    }
    
    public func deregisterPushToken(with token: String) -> AnyPublisher<Bool, Error> {
        self.userService.deregisterPushToken(with: token)
            .map {
                return 200..<300 ~= $0
            }
            .eraseToAnyPublisher()
    }

    public func fetchUserMainInfo() async throws -> UserMainInfoModel {
        let entity = try await userService.getUserMainInfoAsync()
        guard let model = entity.toDomain() else {
            throw MainError.networkError(message: "프로필 정보를 불러올 수 없습니다")
        }
        return model
    }

    public func fetchSoptlogPreview() async throws -> SoptlogModel {
        try await userService.fetchSoptlogInfo().toDomain()
    }

    public func logout() {
        UserDefaultKeyList.clearUserData()
        SFSafariViewController.DataStore.default.clearWebsiteData()
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies({ _ in })
    }
}
