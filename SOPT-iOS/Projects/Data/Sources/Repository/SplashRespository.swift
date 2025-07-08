//
//  SplashRespository.swift
//  Data
//
//  Created by 강윤서 on 7/8/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain

public class SplashRepository {
    
    private let cancelBag = CancelBag()
    
    public init() { }
}

extension SplashRepository: SplashRepositoryInterface {
    
    /// 앱스토어에 배포된 버전을 가져온다.
    public func appStoreVersion() async throws -> String? {
        guard let appId = Bundle.appId,
              let url = URL(string: "https://itunes.apple.com/lookup?id=\(appId)" ) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        guard let results = json?["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            throw UpdateCheckError.appStoreFetchError
        }
        
        return appStoreVersion
    }
    
    /// 최소 지원 버전을 가져온다.
    public func minimumVersion() async throws -> ForceUpdateModel {
        return try await RemoteConfigManager.shared.fetchJsonValue(as: .forcedUpdate, decodeType: ForceUpdateModel.self)
    }
}
