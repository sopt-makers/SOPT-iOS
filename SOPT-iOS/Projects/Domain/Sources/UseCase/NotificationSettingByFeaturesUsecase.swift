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
    func fetchNotificationSettings()
    func updateNotificationSettings(with notificaionSetting: NotificationOptInModel)
    
    var originNotificationInDetail: PassthroughSubject<NotificationOptInModel, Error> { get }
    var updateSuccess: PassthroughSubject<NotificationOptInModel, Error> { get }
}

public final class DefaultNotificationSettingByFeaturesUsecase {
    private let repository: NotificationSettingRepositoryInterface
    
    public let originNotificationInDetail = PassthroughSubject<NotificationOptInModel, Error>()
    public let updateSuccess = PassthroughSubject<NotificationOptInModel, Error>()
    private let cancelBag = CancelBag()
    
    public init(repository: NotificationSettingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultNotificationSettingByFeaturesUsecase: NotificationSettingByFeaturesUsecase {
    public func fetchNotificationSettings() {
        self.repository
            .getNotificationSettingsInDetail()
            .sink { notificationSettings in
                self.originNotificationInDetail.send(notificationSettings)
            }.store(in: self.cancelBag)
    }

    public func updateNotificationSettings(with notificaionSetting: NotificationOptInModel) {
        self.repository
            .updateNotificationSettings(with: notificaionSetting)
            .sink { success in
                self.updateSuccess.send(success)
            }.store(in: self.cancelBag)
    }
}
