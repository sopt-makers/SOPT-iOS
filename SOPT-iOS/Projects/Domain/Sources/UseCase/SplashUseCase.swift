//
//  SplashUseCase.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import ThirdPartyLibs

public enum UpdateType {
    case forcedUpdate(AppNoticeModel)
    case optionalUpdate(AppNoticeModel)
    case none
    case networkError(UpdateCheckError)
}

public enum UpdateCheckError: Error {
    case versionFetchError
}


public protocol SplashUseCase {
    func getAppNotice()
    var needUpdate: PassthroughSubject<UpdateType, Never> { get set }
}

public class DefaultSplashUseCase {
    
    private var cancelBag = CancelBag()
    var updateTask: Task<Void, Never>?
    
    public var needUpdate = PassthroughSubject<UpdateType, Never>()
    
    public init() { }
    
    deinit {
        updateTask?.cancel()
        updateTask = nil
    }
}

extension DefaultSplashUseCase: SplashUseCase {
    public func getAppNotice() {
        #if DEV || PROD
        updateTask = Task {
                do {
                    try await checkedUpdate()
                } catch {
                    print(error)
                    needUpdate.send(.networkError(.versionFetchError))
                }
        }
        #else
        needUpdate.send(.none)
        #endif
    }
    
    /// 앱스토어에 배포된 버전을 가져온다
    private func getAppStoreVersion() async throws -> String? {
        guard let appId = Bundle.appId,
              let url = URL(string: "https://itunes.apple.com/lookup?id=\(appId)" ) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        guard let results = json?["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        
        return appStoreVersion
    }
    
    private func checkedUpdate() async throws {
        // 앱스토어 버전
        guard let appStoreVersion = try await getAppStoreVersion() else {
            throw UpdateCheckError.versionFetchError
        }
        
        // 현재 설치된 앱의 버전
        guard let currentAppVersion = Bundle.appVersion else {
            throw UpdateCheckError.versionFetchError
        }
        
        // 최소 지원 버전
        let forcedUpdateData = try await RemoteConfigManager.shared.fetchJsonValue(as: .forcedUpdate, decodeType: ForceUpdateModel.self)
        let minimumVersion = forcedUpdateData.minimumVersion
        
        let needForceUpdate = currentAppVersion.compare(minimumVersion,options: .numeric) == .orderedAscending
        let needOptionalUpdate = currentAppVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending
        
        if needForceUpdate {            // 강제 업데이트
            needUpdate.send(.forcedUpdate(forcedUpdateData.appNotice))
        }
        else if needOptionalUpdate {    // 선택 업데이트
            let optionalData = try await RemoteConfigManager.shared.fetchJsonValue(as: .optionalUpdate, decodeType: AppNoticeModel.self)
            needUpdate.send(.optionalUpdate(optionalData))
        }
        else {                          // 업데이트 없음
            needUpdate.send(.none)
        }
    }
}
