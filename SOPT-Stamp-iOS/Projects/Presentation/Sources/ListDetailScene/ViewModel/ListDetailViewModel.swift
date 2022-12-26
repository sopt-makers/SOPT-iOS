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
    public var sceneType: ListDetailSceneType!
    public var starLevel: StarViewLevel!
    public var missionId: Int!
    public var missionTitle: String!
  
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let bottomButtonTapped: Driver<ListDetailRequestModel>
        let rightButtonTapped: Driver<ListDetailSceneType>
        let deleteButtonTapped: Driver<Bool>
    }
    
    // MARK: - Outputs
    
    public class Output {
        @Published var listDetailModel: ListDetailModel?
        var editSuccessed = PassthroughSubject<Bool, Never>()
        var showDeleteAlert = PassthroughSubject<Bool, Never>()
        var deleteSuccessed = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: ListDetailUseCase, sceneType: ListDetailSceneType, starLevel: StarViewLevel, missionId: Int, missionTitle: String) {
        self.useCase = useCase
        self.sceneType = sceneType
        self.starLevel = starLevel
        self.missionId = missionId
        self.missionTitle = missionTitle
    }
}

extension ListDetailViewModel {
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                if owner.sceneType == .completed {
                    owner.useCase.fetchListDetail(missionId: owner.missionId)
                }
            }.store(in: cancelBag)
        
        input.bottomButtonTapped
            .sink { requestModel in
                if self.sceneType == ListDetailSceneType.none {
                    self.useCase.postStamp(missionId: self.missionId, stampData: requestModel)
                } else {
                    self.useCase.putStamp(missionId: self.missionId, stampData: requestModel)
                }
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
                // TODO: - useCase 삭제 연결
                self.useCase.deleteStamp(stampId: self.missionId)
            }.store(in: self.cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let listDetailModel = useCase.listDetailModel
        let editSuccess = useCase.editSuccess
        let deleteSuccess = useCase.deleteSuccess
        
        listDetailModel.asDriver()
            .compactMap { $0 }
            .assign(to: \.self.listDetailModel, on: output)
            .store(in: self.cancelBag)
        
        editSuccess.asDriver()
            .sink { success in
                output.editSuccessed.send(success)
            }.store(in: self.cancelBag)
        
        deleteSuccess.asDriver()
            .sink { success in
                output.deleteSuccessed.send(success)
            }.store(in: self.cancelBag)
    }
}
