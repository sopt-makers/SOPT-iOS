//
//  SignUpViewModel.swift
//  Presentation
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class SignUpViewModel: ViewModelType {

    private let useCase: SignUpUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let nicknameCheckButtonTapped: Driver<String?>
        let emailCheckButtonTapped: Driver<String?>
        let passwordTextChanged: Driver<String?>
        let passwordCheckTextChanged: Driver<String?>
        let registerButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var nicknameAlert = PassthroughSubject<String, Never>()
        var emailAlert = PassthroughSubject<String, Never>()
        var passwordAlert = PassthroughSubject<String, Never>()
        var isValidForm = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }
}

extension SignUpViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.nicknameCheckButtonTapped
            .compactMap({ $0 })
            .sink { nickname in
                self.useCase.checkNickname(nickname: nickname)
            }.store(in: self.cancelBag)
        
        input.emailCheckButtonTapped
            .compactMap({ $0 })
            .sink { email in
                self.useCase.checkEmail(email: email)
            }.store(in: self.cancelBag)
        
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
            
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.isNicknameValid.sink { event in
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { isNicknameValid in
            isNicknameValid ? output.nicknameAlert.send("") : output.nicknameAlert.send(I18N.SignUp.duplicatedNickname)
        }.store(in: cancelBag)
        
        useCase.isEmailFormValid.sink { event in
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { isEmailValid in
            isEmailValid ? output.emailAlert.send("") : output.emailAlert.send(I18N.SignUp.invalidEmailForm)
        }.store(in: cancelBag)
        
        useCase.isPasswordFormValid.combineLatest(useCase.isAccordPassword).sink { event in
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { (isFormValid, isAccordValid) in
            if !isFormValid && !isAccordValid {
                output.passwordAlert.send(I18N.SignUp.invalidPasswordForm)
            } else if !isFormValid && isAccordValid {
                output.passwordAlert.send(I18N.SignUp.invalidPasswordForm)
            } else if isFormValid && !isAccordValid {
                output.passwordAlert.send(I18N.SignUp.passwordNotAccord)
            } else {
                output.passwordAlert.send("")
            }
        }.store(in: cancelBag)
        
        useCase.isValidForm.sink { event in
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { isValidForm in
            output.isValidForm.send(isValidForm)
        }.store(in: cancelBag)
    }
}