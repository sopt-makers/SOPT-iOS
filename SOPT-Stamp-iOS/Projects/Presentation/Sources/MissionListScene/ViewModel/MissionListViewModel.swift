//
//  MissionListViewModel.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

@frozen
public enum MissionListSceneType {
    case `default`
    case ranking(userName: String)
}

public class MissionListViewModel: ViewModelType {

    private let useCase: MissionListUseCase
    private var cancelBag = CancelBag()
    public var missionListsceneType: MissionListSceneType!
  
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
    }
    
    // MARK: - init
  
    public init(useCase: MissionListUseCase, sceneType: MissionListSceneType) {
        self.useCase = useCase
        self.missionListsceneType = sceneType
    }
}

extension MissionListViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
