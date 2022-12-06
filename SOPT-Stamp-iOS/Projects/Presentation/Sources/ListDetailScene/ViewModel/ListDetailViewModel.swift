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
        let deleteButtonTapped: Driver<Bool>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var postSuccessed = PassthroughSubject<Bool, Never>()
        var showDeleteAlert = PassthroughSubject<Bool, Never>()
        var deleteSuccessed = PassthroughSubject<Bool, Never>()
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
                // + sceneType(edit / none)
                output.postSuccessed.send(true)
            }.store(in: self.cancelBag)
        
        input.rightButtonTapped
            .sink { sceneType in
                switch sceneType {
                case .completed:
                    output.showDeleteAlert.send(false)
                case .edit:
                    output.showDeleteAlert.send(true)
                default:
                    break
                }
            }.store(in: self.cancelBag)
        
        input.deleteButtonTapped
            .sink { _ in
                // TODO: - useCase
                output.deleteSuccessed.send(false)
            }.store(in: self.cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
