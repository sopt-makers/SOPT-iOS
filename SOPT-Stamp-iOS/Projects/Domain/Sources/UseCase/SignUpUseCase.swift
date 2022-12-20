//
//  SignUpUseCase.swift
//  Domain
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core

public protocol SignUpUseCase {
    func checkNickname(nickname: String)
    func checkEmail(email: String)
    func checkPassword(password: String)
    func checkAccordPassword(firstPassword: String, secondPassword: String)
    
    var isNicknameValid: CurrentValueSubject<Bool, Error> { get set }
    var isEmailFormValid: CurrentValueSubject<Bool, Error> { get set }
    var isPasswordFormValid: CurrentValueSubject<Bool, Error> { get set }
    var isAccordPassword: CurrentValueSubject<Bool, Error> { get set }
    var isValidForm: CurrentValueSubject<Bool, Error> { get set }
}

public class DefaultSignUpUseCase {
  
    private let repository: SignUpRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var isNicknameValid = CurrentValueSubject<Bool, Error>(false)
    public var isEmailFormValid = CurrentValueSubject<Bool, Error>(false)
    public var isPasswordFormValid = CurrentValueSubject<Bool, Error>(false)
    public var isAccordPassword = CurrentValueSubject<Bool, Error>(false)
    public var isValidForm = CurrentValueSubject<Bool, Error>(false)
    
    public init(repository: SignUpRepositoryInterface) {
        self.repository = repository
        self.bindFormValid()
    }
}

extension DefaultSignUpUseCase: SignUpUseCase {
    public func checkNickname(nickname: String) {
        repository.getNicknameAvailable(nickname: nickname)
            .map { statusCode in statusCode == 200 }
            .sink { event in
                print("SignUpUseCase nickname: \(event)")
            } receiveValue: { isValid in
                self.isNicknameValid.send(isValid)
            }.store(in: cancelBag)
    }
    
    public func checkEmail(email: String) {
        let isValid = checkEmailForm(email: email)
        guard isValid else {
            self.isEmailFormValid.send(isValid)
            return
        }
        
        repository.getEmailAvailable(email: email)
            .map { statusCode in statusCode == 200 }
            .sink { event in
                print("SignUpUseCase email: \(event)")
            } receiveValue: { isValid in
                self.isEmailFormValid.send(isValid)
            }.store(in: cancelBag)
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
    func bindFormValid() {
        isNicknameValid.combineLatest(
            isEmailFormValid,
            isPasswordFormValid,
            isAccordPassword)
        .map { (isNicknameValid, isEmailValid, isPasswordValid, isAccordPassword) in
            (isNicknameValid && isEmailValid && isPasswordValid && isAccordPassword)
        }
        .sink { event in
            print("SignUpUseCase - completion: \(event)")
        } receiveValue: { isValid in
            self.isValidForm.send(isValid)
        }.store(in: cancelBag)
    }
    
    func checkEmailForm(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValid = emailTest.evaluate(with: email)
        return isValid
    }
    
    func checkPasswordForm(password: String) {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,15}" // 8자리 ~ 15자리 영어+숫자+특수문자
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let isValid = passwordTest.evaluate(with: password)
        isPasswordFormValid.send(isValid)
    }
    
    func checkAccordPasswordForm(firstPassword: String, secondPassword: String) {
        let isValid = (firstPassword == secondPassword)
        isAccordPassword.send(isValid)
    }
}
