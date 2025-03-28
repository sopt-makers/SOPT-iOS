//
//  MockMainRepository.swift
//  DomainTests
//
//  Created by sejin on 2023/07/05.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import XCTest

import Core
import Domain

final class MockMainRepository: MainRepositoryInterface {
    
    var userInfoModelResponse: Result<UserMainInfoModel?, MainError>!
    
    private(set) var cancelBag = CancelBag()
    
    func getUserMainInfo() -> AnyPublisher<Domain.UserMainInfoModel?, Domain.MainError> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            switch self.userInfoModelResponse {
            case .success(let model):
                promise(.success(model))
            case .failure(let error):
                promise(.failure(error))
            case .none:
                XCTFail("Should Set userInfoModelResponse")
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getMainViewDescription() -> AnyPublisher<Domain.MainDescriptionModel, Domain.MainError> {
        Empty().eraseToAnyPublisher()
    }
    
    func registerPushToken(with token: String) -> AnyPublisher<Bool, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func checkPokeNewUser() -> AnyPublisher<Bool, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func appService() -> AnyPublisher<[Domain.AppServiceModel], any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func hotBoard() -> AnyPublisher<Domain.HotBoardModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getReportUrl() -> AnyPublisher<Domain.SoptampReportUrlModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    
}
