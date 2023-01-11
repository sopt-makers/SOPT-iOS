//
//  SettingUseCase.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public protocol SettingUseCase {
    func resetStamp()
    func editNickname(nickname: String)
    func withdrawal()
    var editNicknameSuccess: PassthroughSubject<Bool, Error> { get set }
    var resetSuccess: PassthroughSubject<Bool, Error> { get set }
    var withdrawalSuccess: PassthroughSubject<Bool, Error> { get set }
}

public class DefaultSettingUseCase {
  
    private let repository: SettingRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var resetSuccess = PassthroughSubject<Bool, Error>()
    public var editNicknameSuccess = PassthroughSubject<Bool, Error>()
    public var withdrawalSuccess = PassthroughSubject<Bool, Error>()
    
    public init(repository: SettingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSettingUseCase: SettingUseCase {
    public func withdrawal() {
        self.repository.withdrawal()
            .withUnretained(self)
            .sink { owner, withdrawalSuccessed in
                owner.withdrawalSuccess.send(withdrawalSuccessed)
            }.store(in: self.cancelBag)
    }
    
    public func editNickname(nickname: String) {
        self.repository.editNickname(nickname: nickname)
            .withUnretained(self)
            .sink { owner, editSuccessed in
                owner.editNicknameSuccess.send(editSuccessed)
            }.store(in: self.cancelBag)
    }
    
    public func resetStamp() {
        repository.resetStamp()
            .sink { success in
                self.resetSuccess.send(success)
            }.store(in: self.cancelBag)
    }
}
