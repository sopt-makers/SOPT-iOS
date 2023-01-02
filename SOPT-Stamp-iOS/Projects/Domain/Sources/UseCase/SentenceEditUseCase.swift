//
//  SentenceEditUseCase.swift
//  Domain
//
//  Created by Junho Lee on 2022/12/22.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public protocol SentenceEditUseCase {
    var originSentenceText: String { get }
    var saveButtonEnabled: PassthroughSubject<Bool, Never> { get set }
    var editSentenceSuccessed: PassthroughSubject<Bool, Never> { get set }
    func validateSentence(text: String)
    func editSentence(sentence: String)
}

public class DefaultSentenceEditUseCase {
  
    private let repository: SettingRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var originSentenceText = UserDefaultKeyList.User.sentence ?? "설정된 한 마디가 없습니다."
    public var saveButtonEnabled = PassthroughSubject<Bool, Never>()
    public var editSentenceSuccessed = PassthroughSubject<Bool, Never>()
  
    public init(repository: SettingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSentenceEditUseCase: SentenceEditUseCase {

    public func validateSentence(text: String) {
        let isDistinctSentence = originSentenceText != text
        self.saveButtonEnabled.send(isDistinctSentence)
    }
    
    public func editSentence(sentence: String) {
        self.repository.editSentence(sentence: sentence)
            .withUnretained(self)
            .sink { owner, editSuccessed in
                owner.editSentenceSuccessed.send(editSuccessed)
            }.store(in: self.cancelBag)
    }
}
