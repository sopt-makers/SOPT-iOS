//
//  RemoteConfigManager.swift
//  Core
//
//  Created by 강윤서 on 7/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import FirebaseRemoteConfig

public final class RemoteConfigManager {
    
    public static let shared = RemoteConfigManager()
    
    // MARK: - Properties
    
    private let config = RemoteConfig.remoteConfig()
    
    // MARK: init
    
    private init() {
        setRemoteConfigSettings()
    }
}

// MARK: - Methods

extension RemoteConfigManager {
    private func setRemoteConfigSettings() {
        let settings = RemoteConfigSettings()
        #if DEV || PROD
        settings.minimumFetchInterval = 0           // 서버에서 새 값을 가져오는 최소 간격
        #else
        settings.minimumFetchInterval = 3600 // 1시간
        #endif
        settings.fetchTimeout = 10
        config.configSettings = settings
    }
    
    /// json 타입 fetch
    public func fetchJsonValue<T: Decodable>(as type: RemoteConfigKey, decodeType: T.Type) async throws -> T {
        let status = try await config.fetchAndActivate()
        guard status == .successFetchedFromRemote || status == .successUsingPreFetchedData else {
            throw RemoteConfigError.fetchFailed
        }
        
        let value = config[type.rawValue].dataValue
        let data = try JSONDecoder().decode(T.self, from: value)
        
        return data
    }
    
    /// string 타입 fetch
    public func fetchStringValue(as type: RemoteConfigKey) async throws -> String? {
        let status = try await config.fetchAndActivate()
        guard status == .successFetchedFromRemote || status == .successUsingPreFetchedData else {
            throw RemoteConfigError.fetchFailed
        }
        let value = config[type.rawValue].stringValue
        return value
    }
}
