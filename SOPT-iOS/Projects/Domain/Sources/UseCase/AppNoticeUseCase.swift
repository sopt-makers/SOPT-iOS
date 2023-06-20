//
//  AppNoticeUseCase.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core

public protocol AppNoticeUseCase {
    func getAppNotice()
    
    var appNoticeModel: PassthroughSubject<AppNoticeModel?, Error> { get set }
}

public class DefaultAppNoticeUseCase {
  
    private let repository: AppNoticeRepositoryInterface
    private var cancelBag = CancelBag()

    public var appNoticeModel = PassthroughSubject<AppNoticeModel?, Error>()
    
    public init(repository: AppNoticeRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultAppNoticeUseCase: AppNoticeUseCase {
    public func getAppNotice() {
        repository.getAppNotice()
        .catch({ error in
            print(error.localizedDescription)
            return Just(AppNoticeModel(withError: true))
        })
        .sink { event in
            print("AppNoticeUseCase : \(event)")
        } receiveValue: { appNoticeModel in
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
}
