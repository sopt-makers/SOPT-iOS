//
//  SoptlogPresentationModel.swift
//  SoptlogFeatureTests
//
//  Created by 강윤서 on 1/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

struct SoptlogPresentationModel {
    let profile: Profile
    let introduce: Introduce
    let appService: [AppService]
    let alarm: Alarm
    
    struct Profile {
        let userName: String
        let profileImage: String
        let part: String
    }
    
    struct Introduce {
        let profileMessage: String
    }

    struct AppService {
        let serviceName: String
        let serviceImageURL: String
        let serviceValue: String
    }

    struct Alarm {
        let isFortuneChecked: Bool
        let todayFortuneText: String
    }
}
