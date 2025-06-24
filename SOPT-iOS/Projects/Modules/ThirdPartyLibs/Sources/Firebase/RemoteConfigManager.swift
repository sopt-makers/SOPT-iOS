//
//  Example.swift
//  ThirdPartyLibs
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import FirebaseRemoteConfig

public enum RemoteConfigType: String {
    case forcedUpdate = "forced_update_notice_iOS"
    case optionalUpdate = "optional_update_notice_iOS"
}

public enum RemoteConfigError: Error {
    case fetchFailed
}

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
        settings.minimumFetchInterval = 0           // 서버에서 새 값을 가져오는 최소 간격
        settings.fetchTimeout = 10
        config.configSettings = settings
    }
    
    public func fetchJsonValue<T: Decodable>(as type: RemoteConfigType, decodeType: T.Type) async throws -> T {
        let status = try await config.fetchAndActivate()
        guard status == .successFetchedFromRemote || status == .successUsingPreFetchedData else {
            throw RemoteConfigError.fetchFailed
        }
        
        let value = config[type.rawValue].dataValue
        let data = try JSONDecoder().decode(T.self, from: value)
        
        return data
    }
    
    public func fetchStringValue(as type: RemoteConfigType) async throws -> String? {
        let status = try await config.fetchAndActivate()
        guard status == .successFetchedFromRemote || status == .successUsingPreFetchedData else {
            throw RemoteConfigError.fetchFailed
        }
        let value = config[type.rawValue].stringValue
        return value
    }
}
