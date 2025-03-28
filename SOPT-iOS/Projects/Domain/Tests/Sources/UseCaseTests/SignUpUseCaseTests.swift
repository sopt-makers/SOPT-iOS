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
        mockCoreOAuthRepository.getIdentityTokenResponse = .success("idtoken.idtoken.idtoken")
        
        // When
        let signUpPublisher = sut.signUp(with: .apple, name: "name", phone: "phone")
        let _ = await signUpPublisher.values.first { _ in true }
        
        // Then
        #expect(mockCoreAuthRepository.signUpRequest == SignUpModel(name: "name", phone: "phone", token: "idtoken.idtoken.idtoken", provider: .apple))
    }
    
    
    @Test
    func 회원가입에_성공했을때_토큰을_레포지토리에_저장한다() {
        
    }
    
    @Test
    func 회원가입에_실패했을때_signUpFail_에러를_방출한다() {
        
    }
}

