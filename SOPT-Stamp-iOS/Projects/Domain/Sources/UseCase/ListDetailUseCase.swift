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
    var listDetailModel: PassthroughSubject<ListDetailModel, Error> { get set }
}

public class DefaultListDetailUseCase {
  
    private let repository: ListDetailRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var listDetailModel = PassthroughSubject<ListDetailModel, Error>()
  
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
}
