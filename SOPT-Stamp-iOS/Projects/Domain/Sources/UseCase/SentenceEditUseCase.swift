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
    func validateSentence(text: String)
}

public class DefaultSentenceEditUseCase {
  
    private let repository: SettingRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var originSentenceText = UserDefaultKeyList.User.sentence ?? "설정된 한 마디가 없습니다."
    public var saveButtonEnabled = PassthroughSubject<Bool, Never>()
  
    public init(repository: SettingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSentenceEditUseCase: SentenceEditUseCase {
    
    public func validateSentence(text: String) {
        let isDistinctSentence = originSentenceText != text
        self.saveButtonEnabled.send(isDistinctSentence)
    }
}
