//
//  ListDetailUseCase.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Core

import Combine

public protocol ListDetailUseCase {
    func fetchListDetail(missionId: Int)
    func postStamp(missionId: Int, stampData: ListDetailRequestModel)
    func putStamp(missionId: Int, stampData: ListDetailRequestModel)
    func deleteStamp(stampId: Int)
    var listDetailModel: PassthroughSubject<ListDetailModel, Error> { get set }
    var editSuccess: PassthroughSubject<Bool, Error> { get set }
    var deleteSuccess: PassthroughSubject<Bool, Error> { get set }
}

public class DefaultListDetailUseCase {
  
    private let repository: ListDetailRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var listDetailModel = PassthroughSubject<ListDetailModel, Error>()
    public var editSuccess = PassthroughSubject<Bool, Error>()
    public var deleteSuccess = PassthroughSubject<Bool, Error>()
  
    public init(repository: ListDetailRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultListDetailUseCase: ListDetailUseCase {
    public func fetchListDetail(missionId: Int) {
        repository.fetchListDetail(missionId: missionId)
            .sink { model in
                self.listDetailModel.send(model)
            }.store(in: self.cancelBag)
    }
    
    public func postStamp(missionId: Int, stampData: ListDetailRequestModel) {
        repository.postStamp(missionId: missionId, stampData: stampData)
            .sink { model in
                self.listDetailModel.send(model)
            }.store(in: self.cancelBag)
    }
    
    public func putStamp(missionId: Int, stampData: ListDetailRequestModel) {
        repository.putStamp(missionId: missionId, stampData: stampData)
            .sink { result in
                self.editSuccess.send(true)
            }.store(in: self.cancelBag)
    }
    
    public func deleteStamp(stampId: Int) {
        repository.deleteStamp(stampId: stampId)
            .sink { success in
                self.deleteSuccess.send(success)
            }.store(in: self.cancelBag)
    }
}
