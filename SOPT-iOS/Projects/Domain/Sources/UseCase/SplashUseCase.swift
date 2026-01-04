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

public enum UpdateType {
    case forcedUpdate(AppNoticeModel)
    case optionalUpdate(AppNoticeModel)
    case none
    case networkError(Error)
}

public enum UpdateCheckError: Error {
    case invalidAppStoreLink
    case appStoreFetchError
    case projectVersionFetchError
}


public protocol SplashUseCase {
    func getAppNotice()
    var needUpdate: PassthroughSubject<UpdateType, Never> { get set }
}

public final class DefaultSplashUseCase {
    
    private let repository: SplashRepositoryInterface
    private var cancelBag = CancelBag()
    var updateTask: Task<Void, Never>?
    
    public var needUpdate = PassthroughSubject<UpdateType, Never>()
    
    public init(repository: SplashRepositoryInterface) {
        self.repository = repository
    }
    
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
                    let type = try await checkedUpdateType()
                    try handleUpdateType(type)
                } catch {
                    // Remote Config 관련 에러는 업데이트 체크를 건너뜁니다.
                    if error is RemoteConfigError {
                        print("Remote Config 에러: \(error)")
                        needUpdate.send(.none)
                        return
                    }
                    
                    switch error {
                    case UpdateCheckError.appStoreFetchError:
                        print("앱스토어에서 최신 버전을 불러오지 못했습니다.")
                        needUpdate.send(.none)
                    case UpdateCheckError.projectVersionFetchError:
                        print("사용자의 버전을 불러오지 못했습니다.")
                        needUpdate.send(.none) 
                    default:
                        print("업데이트 체크 중 에러 발생: \(error)")
                        needUpdate.send(.none)
                    }
                }
        }
        #else
        needUpdate.send(.none)
        #endif
    }
    
    private func checkedUpdateType() async throws -> UpdateType {
        async let getAppStoreVersion = repository.appStoreVersion()                // 앱 스토어 버전
        async let getForcedUpdateData = repository.forcedUpdateData()              // 강제 업데이트 관련 데이터
        async let getOptionalUpdateData = repository.optionalUpdateData()          // 선택 업데이트 관련 데이터
        
        let (appStoreVersion, forcedUpdateData, optionalUpdateData) = try await (getAppStoreVersion, getForcedUpdateData, getOptionalUpdateData)
        let minimumVersion = forcedUpdateData.minimumVersion                       // 최소 지원 버전
        
        // 현재 설치된 앱의 버전
        guard let currentAppVersion = Bundle.appVersion else {
            throw UpdateCheckError.projectVersionFetchError
        }
        
        let needForceUpdate = currentAppVersion.compare(minimumVersion,options: .numeric) == .orderedAscending
        let needOptionalUpdate = currentAppVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending
        
        return needForceUpdate ? .forcedUpdate(forcedUpdateData.appNotice) :
                needOptionalUpdate ? .optionalUpdate(optionalUpdateData) : .none
    }
    
    private func handleUpdateType(_ type: UpdateType) throws {
        switch type {
        case .forcedUpdate(let appNoticeModel):
            needUpdate.send(.forcedUpdate(appNoticeModel))
        case .optionalUpdate(let optionalData):
            needUpdate.send(.optionalUpdate(optionalData))
        case .none:
            needUpdate.send(.none)
        case .networkError(let error):
            throw error
        }
    }
}
