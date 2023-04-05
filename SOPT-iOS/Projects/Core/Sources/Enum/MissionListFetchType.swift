//
//  MissionListFetchType.swift
//  Core
//
//  Created by Junho Lee on 2022/12/21.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public enum MissionListFetchType: String {
    case all
    case complete
    case incomplete
    
    public var path: String {
        return self.rawValue
    }
}
