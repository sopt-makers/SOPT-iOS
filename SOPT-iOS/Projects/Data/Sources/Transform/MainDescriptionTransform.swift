//
//  MainDescriptionTransform.swift
//  Data
//
//  Created by sejin on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension MainDescriptionEntity {
    public func toDomain() -> MainDescriptionModel {
        return MainDescriptionModel.init(topDescription: topDescription, bottomDescription: bottomDescription)
    }
}
