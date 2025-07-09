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
import BaseFeatureDependency

public class MissionListViewModel: MissionListViewModelType {
    
    // MARK: - Trigger
    // TODO: coordinating vc -> vm
    
    public var onSwiped: (() -> Void)?
    public var onNaviBackTap: (() -> Void)?
    public var onPartRankingButtonTap: ((StampFeatureInterface.RankingViewType) -> Void)?
    public var onCurrentGenerationRankingButtonTap: ((StampFeatureInterface.RankingViewType) -> Void)?
    public var onGuideTap: (() -> Void)?
    public var onCellTap: ((Domain.MissionListModel, String?) -> Void)?
    public var onReportButtonTap: (() -> Void)?
    
    // MARK: - Properties
    
    private let useCase: MissionListUseCase
    private let coordinator: AnyCoordinatorObject
    private var cancelBag = CancelBag()
    public var missionListsceneType: MissionListSceneType!
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let viewWillAppear: Driver<Void>
        let missionTypeSelected: CurrentValueSubject<MissionListFetchType, Never>
    }
    
    // MARK: - Outputs
    
    public class Output: NSObject {
        @Published var missionListModel: [MissionListModel]?
        @Published var usersActivateGenerationStatus: UsersActiveGenerationStatusViewResponse?
        @Published var reportUrl: SoptampReportUrlModel?
        var needNetworkAlert = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - init
    
    public init(useCase: MissionListUseCase,
                sceneType: MissionListSceneType,
                coordinator: Coordinator
    ) {
        self.useCase = useCase
        self.missionListsceneType = sceneType
        self.coordinator = coordinator
    }
    
    deinit {
        print("missionlist vm deinit")
    }
}

extension MissionListViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.updateCurrentSoptampUserInfo()
            }.store(in: cancelBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchMissionList(type: input.missionTypeSelected.value)
                owner.useCase.fetchIsActiveGenerationUser()
            }.store(in: cancelBag)
        
        input.missionTypeSelected
            .dropFirst()
            .withUnretained(self)
            .sink { owner, fetchType in
                owner.useCase.fetchMissionList(type: fetchType)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func fetchMissionList(type: MissionListFetchType) {
        switch self.missionListsceneType {
        case .ranking(let userName, _):
            self.useCase.fetchOtherUserMissionList(userName: userName)
        default:
            self.useCase.fetchMissionList(type: type)
            
        }
    }
    
    private func fetchIsActiveGerationUser(type: MissionListFetchType) {
        guard case .default = self.missionListsceneType else { return }
        
        self.useCase.fetchIsActiveGenerationUser()
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let fetchedMissionList = self.useCase.missionListModelsFetched
        
        fetchedMissionList.asDriver()
            .sink(receiveValue: { model in
                output.missionListModel = model
            })
            .store(in: self.cancelBag)
        
        self.useCase
            .usersActiveGenerationInfo
            .asDriver()
            .sink { usersActivateGenerationStatus in
                output.usersActivateGenerationStatus = usersActivateGenerationStatus
            }.store(in: cancelBag)
        
        self.useCase.errorOccurred
            .asDriver()
            .sink { _ in
                output.needNetworkAlert.send()
            }.store(in: cancelBag)
    }
}
