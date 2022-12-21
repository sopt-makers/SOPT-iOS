//
//  MissionListViewModel.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain

@frozen
public enum MissionListSceneType {
    case `default`
    case ranking(userName: String, sentence: String, userId: Int)
}

public class MissionListViewModel: ViewModelType {
    
    private let useCase: MissionListUseCase
    private var cancelBag = CancelBag()
    public var missionListsceneType: MissionListSceneType!
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let viewWillAppear: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public class Output: NSObject {
        @Published var missionListModel: [MissionListModel]?
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
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                switch owner.missionListsceneType {
                case .ranking(_, _, let userId):
                    owner.useCase.fetchOtherUserMissionList(type: .all, userId: userId)
                default:
                    owner.useCase.fetchMissionList(type: .all)
                }
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let fetchedMissionList = self.useCase.missionListModelsFetched
        
        fetchedMissionList.asDriver()
            .sink(receiveValue: { model in
                output.missionListModel = model
            })
            .store(in: self.cancelBag)
    }
}
