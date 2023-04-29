//
//  MainRepository.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class MainRepository {
    
    private let userService: UserService
    private let configService: ConfigService
    private let cancelBag = CancelBag()
    
    public init(userService: UserService, configService: ConfigService) {
        self.userService = userService
        self.configService = configService
    }
}

extension MainRepository: MainRepositoryInterface {
    public func getUserMainInfo() -> AnyPublisher<Domain.UserMainInfoModel?, MainError> {
        return userService.getUserMainInfo()
            .mapError { error -> MainError in
                guard let error = error as? APIError else {
                    print("디버그 여기서 에러")
                    return MainError.networkError
                }
                
                switch error {
                case .network(let statusCode):
                    print("디버그 에러발생 및 상태코드 \(statusCode)")
                    if statusCode == 400 {
                        return MainError.unregisteredUser
                    } else if statusCode == 401 {
                        return MainError.authFailed
                    }
                    return MainError.networkError
                case .tokenReissuanceFailed:
                    
                    guard let appAccessToken = UserDefaultKeyList.Auth.appAccessToken else {
                        return MainError.authFailed
                    }
                    print("디버그 레포에서 토큰 재발급 실패")
                    // accessToken이 빈 스트링인 경우는 플그 미등록 상태 / accessToken이 있지만 인증에 실패한 경우는 로그인 뷰로 보내기
                    return appAccessToken.isEmpty ? MainError.unregisteredUser : MainError.authFailed
                default:
                    print("디버그 디폴트 에러")
                    return MainError.networkError
                }
            }
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getServiceState() -> AnyPublisher<ServiceStateModel, Error> {
        configService.getServiceAvailability()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
