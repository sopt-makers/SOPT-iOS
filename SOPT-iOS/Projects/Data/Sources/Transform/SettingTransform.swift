//
//  SettingTransform.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension SettingEntity {
    public func toDomain() -> SettingModel {
        return SettingModel.init()
    }
}

extension EditSentenceEntity {
    public func toDomain() -> String {
        return profileMessage
    }
}
