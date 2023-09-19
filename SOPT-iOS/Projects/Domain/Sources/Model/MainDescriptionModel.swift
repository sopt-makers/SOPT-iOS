//
//  MainDescriptionModel.swift
//  Domain
//
//  Created by sejin on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public struct MainDescriptionModel {
    public let topDescription: String
    public let bottomDescription: String
    
    public init(topDescription: String, bottomDescription: String) {
        self.topDescription = topDescription
        self.bottomDescription = bottomDescription
    }
}
