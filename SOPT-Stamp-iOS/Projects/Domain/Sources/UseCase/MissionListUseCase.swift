//
//  MissionListUseCase.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol MissionListUseCase {

}

public class DefaultMissionListUseCase {
  
    private let repository: MissionListRepositoryInterface
    private var cancelBag = Set<AnyCancellable>()
  
    public init(repository: MissionListRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultMissionListUseCase: MissionListUseCase {
  
}
