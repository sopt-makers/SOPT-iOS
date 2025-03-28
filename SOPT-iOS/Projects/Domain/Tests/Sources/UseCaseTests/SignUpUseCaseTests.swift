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
        let stub = SignUpModel(
            name: "name",
            phone: "phone",
            token: "idtoken.idtoken.idtoken",
            provider: .apple
        )
        
        mockCoreOAuthRepository.getIdentityTokenResult = .success(stub.token)
        mockCoreAuthRepository.signUpResult = .success(())
        mockCoreAuthRepository.loginResult = .success(.init(accessToken: "", refreshToken: ""))
        
        // When
        var signUpIterator = sut.signUp(
            with: stub.provider,
            name: stub.name,
            phone: stub.phone
        ).values.makeAsyncIterator()
        _ = await signUpIterator.next()
        
        // Then
        #expect(mockCoreAuthRepository.signUpRequest == stub)
    }
    
    
    @Test
    mutating func 회원가입에_성공했을때_토큰을_레포지토리에_저장한다() async {
        // Given
        let stubTokens = CoreAuthTokens(accessToken: "at", refreshToken: "rt")
        
        mockCoreOAuthRepository.getIdentityTokenResult = .success("")
        mockCoreAuthRepository.signUpResult = .success(())
        mockCoreAuthRepository.loginResult = .success(stubTokens)
        
        // When
        var signUpIterator = sut.signUp(with: .apple, name: "", phone: "").values.makeAsyncIterator()
        _ = await signUpIterator.next()
        
        // Then
        #expect(mockCoreAuthRepository.saveTokensRequest == stubTokens)
    }
    
    //TODO
    @Test
    mutating func 애플소셜로그인에서_identitiyToken을_가져오지못하면_00에러를_방출한다() {
        
    }
}
