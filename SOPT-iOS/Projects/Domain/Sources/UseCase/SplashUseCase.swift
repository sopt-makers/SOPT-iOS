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

public protocol SplashUseCase {
    func getAppNotice()
    func registerPushToken()
    
    var appNoticeModel: PassthroughSubject<AppNoticeModel?, Error> { get set }
}

public class DefaultSplashUseCase {
  
    private let repository: SplashRepositoryInterface
    private var cancelBag = CancelBag()

    public var appNoticeModel = PassthroughSubject<AppNoticeModel?, Error>()
    
    public init(repository: SplashRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSplashUseCase: SplashUseCase {
    public func getAppNotice() {
        repository.getAppNotice()
        .catch({ error in
            print(error.localizedDescription)
            return Just(AppNoticeModel(withError: true))
        })
        .sink { event in
            print("DefaultSplashUseCase : \(event)")
        } receiveValue: { appNoticeModel in
#if DEV || TEST
            self.appNoticeModel.send(nil)
            return
#endif
            guard appNoticeModel.withError == false else {
                self.appNoticeModel.send(appNoticeModel)
                return
            }
            guard let currentAppVersion = Bundle.appVersion else { return }
            var appNoticeModel = appNoticeModel
            let checkedAppVersion = self.repository.getCheckedRecommendUpdateVersion() ?? "1.0.0"

            let needForceUpdate = currentAppVersion.compare(appNoticeModel.forceUpdateVersion,
                                                            options: .numeric) == .orderedAscending

            let needRecommendUpdate = checkedAppVersion.compare(appNoticeModel.recommendVersion, options: .numeric) == .orderedAscending && currentAppVersion.compare(appNoticeModel.recommendVersion, options: .numeric) == .orderedAscending

            switch (needForceUpdate, needRecommendUpdate) {
            case (true, _):
                appNoticeModel.setForcedUpdateNotice(isForce: true)
                self.appNoticeModel.send(appNoticeModel)
            case (_, true):
                appNoticeModel.setForcedUpdateNotice(isForce: false)
                self.appNoticeModel.send(appNoticeModel)
            default:
                self.appNoticeModel.send(nil)
            }
        }.store(in: cancelBag)
    }
    
    public func registerPushToken() {
        guard let pushToken = UserDefaultKeyList.User.pushToken, !pushToken.isEmpty else { return }

        repository.registerPushToken(with: pushToken)
            .sink { event in
                print("DefaultSplashUseCase : \(event)")
            } receiveValue: { didSucceed in
                print("푸시 토큰 등록 결과: \(didSucceed)")
            }.store(in: cancelBag)
    }
}
