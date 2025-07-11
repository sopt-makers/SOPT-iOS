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
import Networks

extension AppDelegate {
    var container: DIContainer {
        DIContainer.shared
    }
    
    func registerDependencies() {
        
        container.register(
            interface: AuthTokensRepositoryInterface.self,
            implement: {
                let interceptor = AccessTokenInterceptor()
                let reissueService = DefaultLegacyReissueService(interceptor: interceptor)
                let repository = LegacyAuthTokensRepository(remote: reissueService)
                interceptor.accessTokenClosure = { repository.fetch()?.accessToken  }
                return repository
            }
        )
        
        container.register(
            interface: SignInRepositoryInterface.self,
            implement: {
                SignInRepository(
                    authService: DefaultAuthService.standard,
                    userService: DefaultUserService.standard
                )
            }
        )
        
        container.register(
            interface: PhoneVerifyRepositoryInterface.self,
            implement: {
                PhoneVerifyRepository(
                    coreAuthService: DefaultCoreAuthService.standard
                )
            }
        )
        
        container.register(
            interface: CoreOAuthRepositoryInterface.self,
            implement: {
                CoreOAuthRepository(
                    oAuthServiceFactory: OAuthServiceFactory()
                )
            }
        )
        
        container.register(
            interface: CoreAuthRepositoryInterface.self,
            implement: {
                CoreAuthRepository(
                    coreAuthService: DefaultCoreAuthService.standard,
                    socialService: DefaultSocialService.standard)
            }
        )
        
        container.register(
            interface: SplashRepositoryInterface.self,
            implement: {
                SplashRepository()
            }
        )
        container.register(
            interface: AppMyPageRepositoryInterface.self,
            implement: {
                AppMyPageRepository(
                    stampService: DefaultStampService.standard,
                    userService: DefaultUserService.standard
                )
            }
        )
        container.register(
            interface: NotificationListRepositoryInterface.self,
            implement: {
                NotificationListRepository(
                    service: DefaultNotificationService.standard
                )
            }
        )
        container.register(
            interface: NotificationDetailRepositoryInterface.self,
            implement: {
                NotificationDetailRepository(
                    service: DefaultNotificationService.standard
                )
            }
        )
        container.register(
            interface: SettingRepositoryInterface.self,
            implement: {
                SettingRepository(
                    authService: DefaultAuthService.standard,
                    stampService: DefaultStampService.standard,
                    userService: DefaultUserService.standard
                )
            }
        )
        container.register(
            interface: MissionListRepositoryInterface.self,
            implement: {
                MissionListRepository(
                    missionService: DefaultMissionService.standard,
                    rankService: DefaultRankService.standard,
                    userService: DefaultUserService.standard
                )
            }
        )
        container.register(
            interface: RankingRepositoryInterface.self,
            implement: {
                RankingRepository(
                    service: DefaultRankService.standard
                )
            }
        )
        container.register(
            interface: ListDetailRepositoryInterface.self,
            implement: {
              ListDetailRepository(
                  stampService: DefaultStampService.standard,
                  s3Service: DefaultS3Service.standard,
                  mediaService: DefaultMediaService()
              )
            }
        )
        container.register(
            interface: AttendanceRepositoryInterface.self,
            implement: {
                AttendanceRepository(
                    service: DefaultAttendanceService.standard
                )
            }
        )
        container.register(
            interface: ShowAttendanceRepositoryInterface.self,
            implement: {
                ShowAttendanceRepository(
                    service: DefaultAttendanceService.standard
                )
            }
        )
        container.register(
            interface: NotificationSettingRepositoryInterface.self,
            implement: {
                NotificationSettingRepository(
                    userService: DefaultUserService.standard
                )
            }
        )
        container.register(interface: PokeMainRepositoryInterface.self,
           implement: {
                PokeMainRepository(
                    service: DefaultPokeService.standard
                )
            }
        )
        container.register(interface: PokeMyFriendsRepositoryInterface.self,
           implement: {
                PokeMyFriendsRepository(
                    service: DefaultPokeService.standard
                )
            }
        )
        container.register(
            interface: PokeOnboardingRepositoryInterface.self,
            implement: {
                PokeOnboardingRepository(
                    pokeService: DefaultPokeService.standard
                )
            }
        )
        container.register(
            interface: PokeNotificationRepositoryInterface.self,
            implement: {
                PokeNotificationRepository(
                    pokeService: DefaultPokeService.standard
                )
            }
        )
        container.register(
            interface: DailySoptuneRepositoryInterface.self,
            implement: {
                DailySoptuneRepository(
                    fortuneService: DefaultFortuneService.standard,
                    pokeService: DefaultPokeService.standard
                )
            }
        )
        container.register(
            interface: HomeRepositoryInterface.self,
            implement: {
                HomeRepository(
                    homeService: DefaultHomeService.standard,
                    calendarService: DefaultCalendarService.standard,
                    userService: DefaultUserService.standard,
                    stampService: DefaultStampService.standard,
                    pokeService: DefaultPokeService.standard
                )
            }
        )
        container.register(
            interface: SoptlogRepositoryInterface.self,
            implement: {
                SoptlogRepository(userService: DefaultUserService.standard)
            }
        )
    }
}
