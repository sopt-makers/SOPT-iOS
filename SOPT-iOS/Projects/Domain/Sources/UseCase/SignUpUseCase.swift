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
    
    var isNicknameValid: CurrentValueSubject<(Bool, String), Error> { get set }
}

public class DefaultSignUpUseCase {
    
    private let repository: SignUpRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var isNicknameValid = CurrentValueSubject<(Bool, String), Error>((false, ""))
    
    public init(repository: SignUpRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSignUpUseCase: SignUpUseCase {
    
    public func checkNickname(nickname: String) {
        let nicknameRegEx = "[가-힣ㄱ-ㅣA-Za-z\\s]{1,10}"
        let pred = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
        let isValidForRegex = pred.evaluate(with: nickname)
        let isEmptyNickname = nickname.replacingOccurrences(of: " ", with: "").count == 0
        guard isValidForRegex && !isEmptyNickname else {
            self.isNicknameValid.send((false, I18N.SignUp.nicknameTextFieldPlaceholder))
            return
        }
        
        repository.getNicknameAvailable(nickname: nickname)
            .sink { event in
                print("SignUpUseCase nickname: \(event)")
            } receiveValue: { isValid in
                if isValid {
                    self.isNicknameValid.send((true, I18N.SignUp.validNickname))
                } else {
                    self.isNicknameValid.send((false, I18N.SignUp.duplicatedNickname))
                }
            }.store(in: cancelBag)
    }
}
