//
//  SignUpUseCaseTests.swift
//  DomainTests
//
//  Created by 장석우 on 3/28/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Testing

@testable import Domain

struct SignUpUseCaseTests {
    
    lazy var sut = DefaultSignUpUseCase(
        repository: mockCoreAuthRepository,
        oAuthRepository: mockCoreOAuthRepository
    )
    
    var mockCoreOAuthRepository = MockCoreOAuthRepository()
    var mockCoreAuthRepository = MockCoreAuthRepository()
    
    @Test
    mutating func 회원가입시_identity토큰을_성공적으로_받아왔다면_해당_토큰으로_signUp_요청을_수행한다() async {
        // Given
        mockCoreOAuthRepository.getIdentityTokenResult = .success("idtoken.idtoken.idtoken")
        
        // When
        var signUpIterator = sut.signUp(with: .apple, name: "name", phone: "phone").values.makeAsyncIterator()
        _ = await signUpIterator.next()
        
        // Then
        #expect(mockCoreAuthRepository.signUpRequest == SignUpModel(name: "name", phone: "phone", token: "idtoken.idtoken.idtoken", provider: .apple))
    }
    
    
    @Test
    mutating func 회원가입에_성공했을때_토큰을_레포지토리에_저장한다() async {
        // Given
        let stubTokens = CoreAuthTokens(accessToken: "at", refreshToken: "rt")
        mockCoreOAuthRepository.getIdentityTokenResult = .success("idToken.idToken.idToken")
        mockCoreAuthRepository.signUpResult = .success(())
        mockCoreAuthRepository.loginResult = .success(stubTokens)
        
        // When
        var signUpIterator = sut.signUp(with: .apple, name: "name", phone: "phone").values.makeAsyncIterator()
        _ = await signUpIterator.next()
        
        // Then
        #expect(mockCoreAuthRepository.saveTokensRequest == stubTokens)
    }
    
    @Test
    func 회원가입에_실패했을때_signUpFail_에러를_방출한다() {
        
    }
}

