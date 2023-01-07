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

public enum SignUpFormValidateResult {
    case valid(text: String)
    case invalid(text: String)
}

public class SignUpViewModel: ViewModelType {

    // MARK: - Properties
    
    private let useCase: SignUpUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let nicknameCheckButtonTapped: Driver<String?>
        let emailCheckButtonTapped: Driver<String?>
        let passwordTextChanged: Driver<String?>
        let passwordCheckTextChanged: Driver<String?>
        let registerButtonTapped: Driver<SignUpModel>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var nicknameAlert = PassthroughSubject<SignUpFormValidateResult, Never>()
        var emailAlert = PassthroughSubject<SignUpFormValidateResult, Never>()
        var passwordAlert = PassthroughSubject<SignUpFormValidateResult, Never>()
        var passwordAccordAlert = PassthroughSubject<SignUpFormValidateResult, Never>()
        var isValidForm = PassthroughSubject<Bool, Never>()
        var signUpSuccessed = PassthroughSubject<Bool, Never>()
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
        
        input.registerButtonTapped
            .sink { signUpRequest in
                self.useCase.signUp(signUpRequest: signUpRequest)
            }.store(in: self.cancelBag)
            
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.isNicknameValid.sink { event in
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { isNicknameValid, alertText in
            output.nicknameAlert.send(isNicknameValid ?
                .valid(text: alertText) : .invalid(text: alertText))
        }.store(in: cancelBag)
        
        useCase.isEmailFormValid.sink { event in
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { isEmailValid in
            if !isEmailValid {
                output.emailAlert.send(.invalid(text: I18N.SignUp.invalidEmailForm))
            }
        }.store(in: cancelBag)
        
        useCase.isDuplicateEmail.sink { event in
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { isDuplicateEmail in
            output.emailAlert.send(isDuplicateEmail ? .invalid(text: I18N.SignUp.duplicatedEmail) : .valid(text: I18N.SignUp.validEmail))
        }.store(in: cancelBag)

        useCase.isPasswordFormValid.combineLatest(useCase.isAccordPassword).sink { event in
            print("SignUpViewModel - completion: \(event)")
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
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { isValidForm in
            output.isValidForm.send(isValidForm)
        }.store(in: cancelBag)
        
        useCase.signUpSuccess.sink { event in
            print("SignUpViewModel - completion: \(event)")
        } receiveValue: { isSuccess in
            output.signUpSuccessed.send(isSuccess)
        }.store(in: cancelBag)
    }
}
