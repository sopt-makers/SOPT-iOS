//
//  ListDetailViewModel.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

@frozen
public enum ListDetailSceneType {
    case none // 작성 전
    case completed // 작성 완료
    case edit // 수정
}

public class ListDetailViewModel: ViewModelType {
    
    private let useCase: ListDetailUseCase
    private var cancelBag = CancelBag()
    public var listDetailType: ListDetailSceneType!
    public var starLevel: StarViewLevel!
  
    // MARK: - Inputs
    
    public struct Input {
        let bottomButtonTapped: Driver<ListDetailRequestModel>
        let rightButtonTapped: Driver<ListDetailSceneType>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        // TODO: - 수정
        var successed = PassthroughSubject<Bool, Never>()
        var changeToEdit = PassthroughSubject<Bool, Never>()
        var deleteSuccess = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: ListDetailUseCase, sceneType: ListDetailSceneType, starLevel: StarViewLevel) {
        self.useCase = useCase
        self.listDetailType = sceneType
        self.starLevel = starLevel
    }
}

extension ListDetailViewModel {
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.bottomButtonTapped
            .sink { requestModel in
                print("✅requestModel:", requestModel)
                // TODO: - useCase
                output.successed.send(true)
            }.store(in: self.cancelBag)
        
        input.rightButtonTapped
            .sink { sceneType in
                switch sceneType {
                case .completed:
                    output.changeToEdit.send(true)
                case .edit:
                    // TODO: - useCase
                    output.deleteSuccess.send(false)
                default:
                    break
                }
            }.store(in: self.cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
