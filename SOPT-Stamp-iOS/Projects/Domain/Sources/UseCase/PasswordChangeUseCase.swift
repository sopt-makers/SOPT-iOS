//
//  PasswordChangeUseCase.swift
//  Domain
//
//  Created by sejin on 2022/12/26.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core

public protocol PasswordChangeUseCase {
    func checkPassword(password: String)
    func checkAccordPassword(firstPassword: String, secondPassword: String)
    func changePassword(password: String)
    
    var isPasswordFormValid: CurrentValueSubject<Bool, Error> { get set }
    var isAccordPassword: CurrentValueSubject<Bool, Error> { get set }
    var isValidForm: CurrentValueSubject<Bool, Error> { get set }
    var passwordChangeSuccess: CurrentValueSubject<Bool, Error> { get set }
}

public class DefaultPasswordChangeUseCase {
    
    private let repository: PasswordChangeRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var isPasswordFormValid = CurrentValueSubject<Bool, Error>(false)
    public var isAccordPassword = CurrentValueSubject<Bool, Error>(false)
    public var isValidForm = CurrentValueSubject<Bool, Error>(false)
    public var passwordChangeSuccess = CurrentValueSubject<Bool, Error>(false)

    public init(repository: PasswordChangeRepositoryInterface) {
        self.repository = repository
        self.bindFormValid()
    }
}

extension DefaultPasswordChangeUseCase: PasswordChangeUseCase {
    public func checkPassword(password: String) {
        checkPasswordForm(password: password)
    }
    
    public func checkAccordPassword(firstPassword: String, secondPassword: String) {
        checkAccordPasswordForm(firstPassword: firstPassword, secondPassword: secondPassword)
    }
    
    public func changePassword(password: String) {
        repository.changePassword(password: password)
            .sink { event in
                print("PasswordChangeUseCase: \(event)")
            } receiveValue: { isSuccess in
                self.passwordChangeSuccess.send(isSuccess)
            }.store(in: cancelBag)
    }
}

// MARK: - Methods

extension DefaultPasswordChangeUseCase {
    func bindFormValid() {
        isPasswordFormValid.combineLatest(isAccordPassword)
        .map { (isPasswordValid, isAccordPassword) in
            (isPasswordValid && isAccordPassword)
        }
        .sink { event in
            print("PasswordChangeUseCase - completion: \(event)")
        } receiveValue: { isValid in
            self.isValidForm.send(isValid)
        }.store(in: cancelBag)
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
