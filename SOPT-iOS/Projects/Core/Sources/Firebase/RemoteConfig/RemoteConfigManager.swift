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
        settings.minimumFetchInterval = 3600           // 서버에서 새 값을 가져오는 최소 간격
        #else
        settings.minimumFetchInterval = 3600 // 1시간
        #endif
        settings.fetchTimeout = 10
        config.configSettings = settings
    }
    
    /// json 타입 fetch
    public func fetchJsonValue<T: Decodable>(as type: RemoteConfigKey, decodeType: T.Type) async throws -> T {
        // fetch 시도, 실패해도 기존 활성화된 값을 사용할 수 있도록 처리합니다.
        do {
            _ = try await config.fetchAndActivate()
        } catch {
            print("fetchJsonValue error", error)
        }
        
        let value = config[type.rawValue].dataValue
        
        guard !value.isEmpty else {
            throw RemoteConfigError.valueNotFound
        }
        
        do {
            let data = try JSONDecoder().decode(T.self, from: value)
            return data
        } catch {
            throw RemoteConfigError.decodeFailed
        }
    }
    
    /// string 타입 fetch
    public func fetchStringValue(as type: RemoteConfigKey) async throws -> String? {
        // fetch 시도, 실패해도 기존 활성화된 값을 사용할 수 있도록 처리
        do {
            _ = try await config.fetchAndActivate()
        } catch {
            print("fetchStringValue error", error)
        }
        
        let value = config[type.rawValue].stringValue
        return value
    }
}
