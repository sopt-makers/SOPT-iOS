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
    private var cancelBag = Set<AnyCancellable>()
    public var listDetailType: ListDetailSceneType!
  
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
    }
    
    // MARK: - init
  
    public init(useCase: ListDetailUseCase, sceneType: ListDetailSceneType) {
        self.useCase = useCase
        self.listDetailType = sceneType
    }
}

extension ListDetailViewModel {
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
