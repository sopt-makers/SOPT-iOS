//
//  RemoteConfigManager.swift
//  Core
//
//  Created by 강윤서 on 5/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Firebase
import FirebaseRemoteConfig

public final class RemoteConfigManager {
    
    static let shared = RenoteConfigManager()
    
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
        settings.minimumFetchInterval = 0
        settings.fetchTimeout = 1
        config.configSettings = settings
    }
}
