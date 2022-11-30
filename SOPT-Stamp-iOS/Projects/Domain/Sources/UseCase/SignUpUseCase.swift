//
//  SignUpUseCase.swift
//  Domain
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

public protocol SignUpUseCase {
    func checkNickname(nickname: String)
    func checkEmail(email: String)
    func checkPassword(password: String)
    func checkAccordPassword(firstPassword: String, secondPassword: String)
    
    var isNicknameValid: CurrentValueSubject<Bool, Error> { get set }
    var isEmailFormValid: CurrentValueSubject<Bool, Error> { get set }
    var isPasswordFormValid: CurrentValueSubject<Bool, Error> { get set }
    var isAccordPassword: CurrentValueSubject<Bool, Error> { get set }
}

public class DefaultSignUpUseCase {
  
    private let repository: SignUpRepositoryInterface
    private var cancelBag = Set<AnyCancellable>()
    
    public var isNicknameValid = CurrentValueSubject<Bool, Error>(false)
    public var isEmailFormValid = CurrentValueSubject<Bool, Error>(false)
    public var isPasswordFormValid = CurrentValueSubject<Bool, Error>(false)
    public var isAccordPassword = CurrentValueSubject<Bool, Error>(false)
  
    public init(repository: SignUpRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSignUpUseCase: SignUpUseCase {
    public func checkNickname(nickname: String) {
        // 닉네임 글자 수 정해지면 로직 추가
        let isValid = checkNicknameForm(nickname: nickname)
        guard isValid else { return }
        // 서버 통신
    }
    
    public func checkEmail(email: String) {
        let isValid = checkEmailForm(email: email)
        guard isValid else { return }
        // 서버 통신
    }
    
    public func checkPassword(password: String) {
        checkPasswordForm(password: password)
    }
    
    public func checkAccordPassword(firstPassword: String, secondPassword: String) {
        checkAccordPasswordForm(firstPassword: firstPassword, secondPassword: secondPassword)
    }
}

// MARK: - Methods

extension DefaultSignUpUseCase {
    func checkNicknameForm(nickname: String) -> Bool {
        isNicknameValid.send(true)
        return true
    }
    
    func checkEmailForm(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValid = emailTest.evaluate(with: email)
        isEmailFormValid.send(isValid)
        return isValid
    }
    
    func checkPasswordForm(password: String) {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,16}" // 8자리 ~ 16자리 영어+숫자+특수문자
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let isValid = passwordTest.evaluate(with: password)
        isPasswordFormValid.send(isValid)
    }
    
    func checkAccordPasswordForm(firstPassword: String, secondPassword: String) {
        let isValid = (firstPassword == secondPassword)
        isAccordPassword.send(isValid)
    }
}
