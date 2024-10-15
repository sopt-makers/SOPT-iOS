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

public class MissionListViewModel: ViewModelType {
  
  private let useCase: MissionListUseCase
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
        owner.useCase.updateCurrentSoptampUserInfo()
      }.store(in: cancelBag)
    
    input.viewWillAppear
      .withUnretained(self)
      .sink { owner, _ in
        owner.fetchMissionList(type: input.missionTypeSelected.value)
        owner.useCase.fetchIsActiveGenerationUser()
        owner.useCase.getReportUrl()
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
      }.store(in: self.cancelBag)
      
    self.useCase.reportUrl
      .asDriver()
      .sink { url in
        output.reportUrl = url
      }.store(in: cancelBag)
    
    self.useCase.errorOccurred
      .asDriver()
      .sink { _ in
          output.needNetworkAlert.send()
      }.store(in: cancelBag)
  }
}
