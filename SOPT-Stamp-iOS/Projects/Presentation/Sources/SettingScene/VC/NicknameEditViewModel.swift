//
//  NicknameEditViewModel.swift
//  Presentation
//
//  Created by Junho Lee on 2023/01/02.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

public class NicknameEditViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let nicknameCheckUseCase: SignUpUseCase
    private let editPostUseCase: SettingUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let nicknameTextChanged: Driver<String>
        let editButtonTapped: Driver<String>
    }
    
    // MARK: - Outputs
    
    public class Output {
        var nicknameAlert = PassthroughSubject<SignUpFormValidateResult, Never>()
        @Published var editButtonEnabled = false
        var editNicknameSuccessed = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
    
    public init(nicknameUseCase: SignUpUseCase, editPostUseCase: SettingUseCase) {
        self.nicknameCheckUseCase = nicknameUseCase
        self.editPostUseCase = editPostUseCase
    }
}

extension NicknameEditViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.nicknameTextChanged
            .handleEvents(receiveOutput: { _ in
                output.editButtonEnabled = false
            })
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .withUnretained(self)
            .sink { owner, nickname in
                if nickname.isEmpty {
                    output.nicknameAlert.send(.invalid(text: I18N.SignUp.nicknameTextFieldPlaceholder))
                } else {
                    owner.nicknameCheckUseCase.checkNickname(nickname: nickname)
                }
            }.store(in: self.cancelBag)
        
        input.editButtonTapped
            .withUnretained(self)
            .sink { owner, nickname in
                owner.editPostUseCase.editNickname(nickname: nickname)
            }.store(in: self.cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        nicknameCheckUseCase.isNicknameValid
            .asDriver()
            .sink { isNicknameValid in
                output.editButtonEnabled = isNicknameValid
                output.nicknameAlert.send(isNicknameValid
                                          ? .valid(text: I18N.SignUp.validNickname)
                                          : .invalid(text: I18N.SignUp.duplicatedNickname))
            }.store(in: self.cancelBag)
        
        editPostUseCase.editNicknameSuccess
            .asDriver()
            .sink { isSuccessed in
                output.editNicknameSuccessed.send(isSuccessed)
            }.store(in: self.cancelBag)
    }
}
