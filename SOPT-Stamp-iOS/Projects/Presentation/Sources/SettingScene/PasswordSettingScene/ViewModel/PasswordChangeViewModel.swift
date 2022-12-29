//
//  PasswordChangeViewModel.swift
//  Presentation
//
//  Created by sejin on 2022/12/26.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Combine

import Core
import Domain

public class PasswordChangeViewModel: ViewModelType {

    private let useCase: PasswordChangeUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let passwordTextChanged: Driver<String?>
        let passwordCheckTextChanged: Driver<String?>
        let passwordChangeButtonTapped: Driver<String>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var passwordAlert = PassthroughSubject<SignUpFormValidateResult, Never>()
        var passwordAccordAlert = PassthroughSubject<SignUpFormValidateResult, Never>()
        var isValidForm = PassthroughSubject<Bool, Never>()
        var passwordChangeSuccessed = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: PasswordChangeUseCase) {
        self.useCase = useCase
    }
}

extension PasswordChangeViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.passwordTextChanged
            .compactMap({ $0 })
            .sink { password in
                self.useCase.checkPassword(password: password)
            }.store(in: self.cancelBag)
        
        input.passwordTextChanged
            .compactMap({ $0 })
            .combineLatest(input.passwordCheckTextChanged.compactMap({ $0 }))
            .sink { (firstPassword, secondPassword) in
                self.useCase.checkAccordPassword(firstPassword: firstPassword, secondPassword: secondPassword)
            }.store(in: self.cancelBag)
        
        input.passwordChangeButtonTapped
            .sink { password in
                self.useCase.changePassword(password: password)
            }.store(in: self.cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.isPasswordFormValid.combineLatest(useCase.isAccordPassword).sink { event in
            print("PasswordChangeViewModel - completion: \(event)")
        } receiveValue: { (isFormValid, isAccordValid) in
            if !isFormValid {
                output.passwordAlert.send(.invalid(text: I18N.SignUp.invalidPasswordForm))
            } else if isFormValid && !isAccordValid {
                output.passwordAlert.send(.valid(text: ""))
                output.passwordAccordAlert.send(.invalid(text: (I18N.SignUp.passwordNotAccord)))
            } else {
                output.passwordAlert.send(.valid(text: ""))
                output.passwordAccordAlert.send(.valid(text: ""))
            }
        }.store(in: cancelBag)
        
        useCase.isValidForm.sink { event in
            print("PasswordChangeViewModel - completion: \(event)")
        } receiveValue: { isValidForm in
            output.isValidForm.send(isValidForm)
        }.store(in: cancelBag)
        
        useCase.passwordChangeSuccess.sink { event in
            print("PasswordChangeViewModel - completion: \(event)")
        } receiveValue: { isSuccess in
            output.passwordChangeSuccessed.send(isSuccess)
        }.store(in: cancelBag)
    }
}
