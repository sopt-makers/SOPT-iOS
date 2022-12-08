//
//  ListDetailUseCase.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol ListDetailUseCase {

}

public class DefaultListDetailUseCase {
  
    private let repository: ListDetailRepositoryInterface
    private var cancelBag = Set<AnyCancellable>()
  
    public init(repository: ListDetailRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultListDetailUseCase: ListDetailUseCase {
  
}
