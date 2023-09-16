//
//  RegisterDependencies.swift
//  SOPT-iOS
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

import Domain
import Data
import Network

extension AppDelegate {
    var container: DIContainer {
        DIContainer.shared
    }
    
    func registerDependencies() {
        container.register(
            interface: SignInRepositoryInterface.self,
            implement: {
                SignInRepository(
                    authService: DefaultAuthService(),
                    userService: DefaultUserService()
                )
            }
        )
        container.register(
            interface: SplashRepositoryInterface.self,
            implement: {
                SplashRepository(service: DefaultFirebaseService(), userService: DefaultUserService())
            }
        )
        container.register(
            interface: MainRepositoryInterface.self,
            implement: {
                MainRepository(
                    userService: DefaultUserService(),
                    configService: DefaultConfigService()
                )
            }
        )
        container.register(
            interface: AppMyPageRepositoryInterface.self,
            implement: {
                AppMyPageRepository(
                    stampService: DefaultStampService()
                )
            }
        )
        container.register(
            interface: NotificationListRepositoryInterface.self,
            implement: {
                NotificationListRepository(
                    service: DefaultUserService()
                )
            }
        )
        container.register(
            interface: NotificationDetailRepositoryInterface.self,
            implement: {
                NotificationDetailRepository(
                    service: DefaultUserService()
                )
            }
        )
        container.register(
            interface: SettingRepositoryInterface.self,
            implement: {
                SettingRepository(
                    authService: DefaultAuthService(),
                    stampService: DefaultStampService(),
                    userService: DefaultUserService()
                )
            }
        )
        container.register(
            interface: SignUpRepositoryInterface.self,
            implement: {
                SignUpRepository(
                    service: DefaultUserService()
                )
            }
        )
        container.register(
            interface: MissionListRepositoryInterface.self,
            implement: {
                MissionListRepository(
                    missionService: DefaultMissionService(),
                    rankService: DefaultRankService()
                )
            }
        )
        container.register(
            interface: RankingRepositoryInterface.self,
            implement: {
                RankingRepository(
                    service: DefaultRankService()
                )
            }
        )
        container.register(
            interface: ListDetailRepositoryInterface.self,
            implement: {
                ListDetailRepository(
                    service: DefaultStampService()
                )
            }
        )
        container.register(
            interface: AttendanceRepositoryInterface.self,
            implement: {
                AttendanceRepository(
                    service: DefaultAttendanceService()
                )
            }
        )
        container.register(
            interface: ShowAttendanceRepositoryInterface.self,
            implement: {
                ShowAttendanceRepository(
                    service: DefaultAttendanceService()
                )
            }
        )
    }
}
