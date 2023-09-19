//
//  NotificationSettingByFeaturesUsecase.swift
//  Domain
//
//  Created by Ian on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Combine

public protocol NotificationSettingByFeaturesUsecase {
    func updateNotificationSettings(with notificaionSetting: NotificationOptInModel)
    
    var updateSuccess: PassthroughSubject<Bool, Error> { get }
}

public final class DefaultNotificationSettingByFeaturesUsecase {
    private let repository: NotificationSettingRepositoryInterface
    
    public let updateSuccess = PassthroughSubject<Bool, Error>()
    private let cancelBag = CancelBag()
    
    public init(repository: NotificationSettingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultNotificationSettingByFeaturesUsecase: NotificationSettingByFeaturesUsecase {
    public func updateNotificationSettings(with notificaionSetting: NotificationOptInModel) {
        self.repository
            .updateNotificationSettings(with: notificaionSetting)
            .sink { success in
                self.updateSuccess.send(success)
            }.store(in: self.cancelBag)
    }
}
