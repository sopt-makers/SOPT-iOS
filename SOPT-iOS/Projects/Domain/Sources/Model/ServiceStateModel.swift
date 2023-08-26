//
//  ServiceStateModel.swift
//  Domain
//
//  Created by sejin on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ServiceStateModel: Equatable {
    public let isAvailable: Bool
    
    public init(isAvailable: Bool) {
        self.isAvailable = isAvailable
    }
}
