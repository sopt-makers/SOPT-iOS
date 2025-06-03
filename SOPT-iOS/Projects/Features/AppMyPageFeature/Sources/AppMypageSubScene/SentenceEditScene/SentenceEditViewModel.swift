//
//  SentenceEditViewModel.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/22.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class SentenceEditViewModel: ViewModelType {

    private let useCase: SentenceEditUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let textChanged: Driver<String>
        let saveButtonTapped: Driver<String>
    }
    
    // MARK: - Outputs
    
    public class Output {
        @Published var saveButtonEnabled = false
        @Published var defaultText = ""
        let editSuccessed = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: SentenceEditUseCase) {
        self.useCase = useCase
    }
}

extension SentenceEditViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.textChanged
            .withUnretained(self)
            .sink { owner, text in
                owner.useCase.validateSentence(text: text)
            }.store(in: self.cancelBag)
        
        input.saveButtonTapped
            .withUnretained(self)
            .sink { owner, sentence in
                owner.useCase.editSentence(sentence: sentence)
            }.store(in: self.cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        self.useCase.saveButtonEnabled
            .asDriver()
            .sink { isEnabled in
                output.saveButtonEnabled = isEnabled
            }.store(in: self.cancelBag)
        
        output.defaultText = self.useCase.originSentenceText
        
        self.useCase.editSentenceSuccessed
            .asDriver()
            .sink { isSuccessed in
                output.editSuccessed.send(isSuccessed)
            }.store(in: self.cancelBag)
    }
}
