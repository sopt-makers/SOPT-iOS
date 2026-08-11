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
    public var onEditTap: (() -> Void)?
    public var onCellTap: ((Domain.MissionListModel, String?) -> Void)?
    public var onReportButtonTap: (() -> Void)?
    public var onAppJamRankingButtonTap: (() -> Void)?
    
    // MARK: - Properties
    
    private let useCase: MissionListUseCase
    private let coordinator: AnyCoordinatorObject
    private var cancelBag = CancelBag()
    public var missionListsceneType: MissionListSceneType!
    private var isAppjamMode: Bool = false
    
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
        @Published var appjamInfo: AppjamMissionListModel?
        @Published var isAppjamMode: Bool?
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
}

extension MissionListViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.updateCurrentSoptampUserInfo()
                if case .default = owner.missionListsceneType {
                    owner.useCase.fetchIsAppjamMode()
                }
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
                owner.fetchMissionListByType(type: fetchType)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func fetchMissionList(type: MissionListFetchType) {
        switch self.missionListsceneType {
        case .ranking(let userName, _):
            self.useCase.fetchOtherUserMissionList(userName: userName)
        case .appJamTeam(_, let teamNumber):
            self.useCase.fetchAppjamMissionList(teamNumber: teamNumber, isCompleted: true)
        default:
            fetchMissionListByType(type: type)
        }
    }
    
    private func fetchMissionListByType(type: MissionListFetchType) {
        guard isAppjamMode else {
            switch type {
            case .appjam:
                self.useCase.fetchAppjamMissionList(teamNumber: nil, isCompleted: nil)
            default:
                self.useCase.fetchMissionList(type: type)
            }
            return
        }

        switch type {
        case .all:
            self.useCase.fetchAppjamMissionList(teamNumber: nil, isCompleted: nil)
        case .complete:
            self.useCase.fetchAppjamMissionList(teamNumber: nil, isCompleted: true)
        case .incomplete:
            self.useCase.fetchAppjamMissionList(teamNumber: nil, isCompleted: false)
        case .appjam:
            self.useCase.fetchAppjamMissionList(teamNumber: nil, isCompleted: nil)
        }
    }
    
    private func fetchIsActiveGerationUser(type: MissionListFetchType) {
        guard case .default = self.missionListsceneType else { return }
        
        self.useCase.fetchIsActiveGenerationUser()
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let fetchedMissionList = self.useCase.missionListModelsFetched
        let fetchedAppjamMissionList = self.useCase.appjamMissionListModelFetched
        
        fetchedMissionList.asDriver()
            .sink(receiveValue: { model in
                output.missionListModel = model
            })
            .store(in: self.cancelBag)
        
        fetchedAppjamMissionList.asDriver()
            .sink(receiveValue: { model in
                output.missionListModel = model.missions
                output.appjamInfo = model
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

        self.useCase.isAppjamModeFetched
            .asDriver()
            .withUnretained(self)
            .sink { owner, isAppjamMode in
                owner.isAppjamMode = isAppjamMode
                output.isAppjamMode = isAppjamMode
            }.store(in: cancelBag)
    }
}
