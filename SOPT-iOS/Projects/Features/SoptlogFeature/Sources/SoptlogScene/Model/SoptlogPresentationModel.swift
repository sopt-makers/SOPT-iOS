//
//  SoptlogPresentationModel.swift
//  SoptlogFeatureTests
//
//  Created by 강윤서 on 1/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain

struct SoptlogPresentationModel {
    let profile: Profile
    let introduce: Introduce
    let appService: [AppService]
    let alarm: Alarm
    
    struct Profile {
        let userName: String?
        let profileImage: String?
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

extension SoptlogModel {
    func toPresentation() -> SoptlogPresentationModel {
        var appService: [SoptlogPresentationModel.AppService] = []
        appService.append(SoptlogPresentationModel.AppService(
            serviceName: I18N.Soptlog.soptlevel,
            serviceImageURL: self.icons[0],
            serviceValue: self.soptLevel))
        appService.append(SoptlogPresentationModel.AppService(
            serviceName: I18N.Soptlog.poke,
            serviceImageURL: self.icons[1],
            serviceValue: self.pokeCount))
        
        if self.isActive {
            appService.append(SoptlogPresentationModel.AppService(
                serviceName: I18N.Soptlog.soptamp,
                serviceImageURL: self.icons[2],
                serviceValue: self.soptampRank))
        } else {
            appService.append(SoptlogPresentationModel.AppService(
                serviceName: I18N.Soptlog.withSopt,
                serviceImageURL: self.icons[2],
                serviceValue: self.during))
        }
        
        
        return SoptlogPresentationModel(
            profile: SoptlogPresentationModel.Profile(
                userName: self.userName,
                profileImage: self.profileImage,
                part: self.part
            ),
            introduce: SoptlogPresentationModel.Introduce(
                profileMessage: self.profileMessage
            ),
            appService: appService,
            alarm: SoptlogPresentationModel.Alarm(
                isFortuneChecked: self.isFortuneChecked,
                todayFortuneText: self.todayFortuneText
            )
        )
    }
}
