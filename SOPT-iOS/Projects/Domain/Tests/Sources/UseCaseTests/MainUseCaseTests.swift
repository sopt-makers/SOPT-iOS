//
//  MainUseCaseTests.swift
//  DomainTests
//
//  Created by sejin on 2023/07/05.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import XCTest
import Combine
import Core

@testable import Domain

final class DefaultMainUseCaseTests: XCTestCase {
    private var useCase: DefaultMainUseCase!
    private var repository: MockMainRepository!
    
    override func setUp() {
        super.setUp()
        repository = MockMainRepository()
        useCase = DefaultMainUseCase(repository: repository)
    }
    
    override func tearDown() {
        useCase = nil
        repository = nil
        super.tearDown()
    }
    
    func test_getUserMainInfo_activeUser() {
        // Given
        let expectation = XCTestExpectation(description: "GetUserMainInfo")
        
        let userMainInfo = activeUserInfoModel
        repository.userInfoModelResponse = .success(userMainInfo)
        var result: UserMainInfoModel!
        
        // When
        useCase.userMainInfo
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { model in
                result = model
                expectation.fulfill()
            }
            .store(in: repository.cancelBag)
        
        useCase.getUserMainInfo()
        
        wait(for: [expectation], timeout: 0.5)
        
        // Then
        XCTAssertEqual(result, userMainInfo)
        let userType = UserDefaultKeyList.Auth.isActiveUser!
        XCTAssertTrue(userType)
    }
    
    
    func test_getUserMainInfo_inActiveUser() {
        // Given
        let expectation = XCTestExpectation(description: "GetUserMainInfo")
        
        let userMainInfo = inactiveUserInfoModel
        repository.userInfoModelResponse = .success(userMainInfo)
        var result: UserMainInfoModel!

        // When
        useCase.userMainInfo
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { model in
                result = model
                expectation.fulfill()
            }
            .store(in: repository.cancelBag)
        
        useCase.getUserMainInfo()
        
        wait(for: [expectation], timeout: 0.5)
        
        // Then
        XCTAssertEqual(result, userMainInfo)
        let userType = UserDefaultKeyList.Auth.isActiveUser!
        XCTAssertFalse(userType)
    }
    
    func test_getUserMainInfo_ErrorOccurred() {
        // Given
        let expectation = XCTestExpectation(description: "GetUserMainInfo")
        let expectationError: MainError = .authFailed
        repository.userInfoModelResponse = .failure(expectationError)
        var result: MainError!
        
        // When
        useCase.mainErrorOccurred
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { errorModel in
                result = errorModel
                expectation.fulfill()
            }
            .store(in: repository.cancelBag)
        
        useCase.getUserMainInfo()
        
        wait(for: [expectation], timeout: 0.5)
        
        // Then
        XCTAssertEqual(result, expectationError)
    }
    
    func test_getServiceState() {
        // Given
        let expectation = XCTestExpectation(description: "GetServiceState")
        let isAvailable = true
        let serviceStateModel = ServiceStateModel(isAvailable: isAvailable)
        repository.serviceStateModelResponse = .success(serviceStateModel)
        var result: ServiceStateModel!
        
        // When
        useCase.serviceState
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { model in
                result = model
                expectation.fulfill()
            }.store(in: repository.cancelBag)

        useCase.getServiceState()
        
        wait(for: [expectation], timeout: 0.5)
        
        // Then
        XCTAssertEqual(result.isAvailable, isAvailable)
    }
    
    func test_getServiceState_ErrorOccurred() {
        // Given
        let expectation = XCTestExpectation(description: "GetUserMainInfo")
        let expectationError: MainError = .authFailed
        repository.serviceStateModelResponse = .failure(expectationError)
        var result: MainError!
        
        // When
        useCase.mainErrorOccurred
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { errorModel in
                result = errorModel
                expectation.fulfill()
            }
            .store(in: repository.cancelBag)
        
        useCase.getServiceState()
        
        wait(for: [expectation], timeout: 0.5)
        
        // Then
        XCTAssertEqual(result, .networkError(message: "GetServiceState 실패"))
    }
}

extension DefaultMainUseCaseTests {
    var activeUserInfoModel: UserMainInfoModel {
        return UserMainInfoModel(status: "ACTIVE",
                                 name: "솝트",
                                 profileImage: nil,
                                 historyList: [32, 25],
                                 attendanceScore: 2.0,
                                 announcement: nil,
                                 isAllConfirm: true)
    }
    
    var inactiveUserInfoModel: UserMainInfoModel {
        return UserMainInfoModel(status: "INACTIVE",
                                 name: "솝트",
                                 profileImage: nil,
                                 historyList: [32, 25],
                                 attendanceScore: 2.0,
                                 announcement: nil,
                                 isAllConfirm: true)
    }
}
