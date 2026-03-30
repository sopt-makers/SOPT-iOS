//
//  ClapListViewModel.swift
//  StampFeature
//
//  Created by 성현주 on 10/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import BaseFeatureDependency

public class ClapListViewModel: ClapListViewModelType {

    // MARK: - Triggers

    public var onNaviBackTap: (() -> Void)?
    public var onCellTap: ((String?, String?) -> Void)?

    // MARK: - Properties

    private let useCase: ListDetailUseCase
    private var cancelBag = CancelBag()
    public var stampId: Int?
    public var nickname: String?

    // MARK: - Inputs

    public struct Input {
        let viewDidLoad: Driver<Void>
    }

    // MARK: - Outputs

    public class Output: NSObject {
        @Published var clapListModel: [ClapperModel]?
    }

    // MARK: - init

    public init(useCase: ListDetailUseCase) {
        self.useCase = useCase
    }
}

extension ClapListViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)

        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                guard let stampId = owner.stampId,
                      let nickname = owner.nickname else { return }
                owner.useCase.getClapList(stampId: stampId, nickname: nickname)
            }.store(in: cancelBag)
        return output
    }

    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let fetchedClapList = self.useCase.clapListModel

        fetchedClapList.asDriver()
            .sink(receiveValue: { models in
                output.clapListModel = models
            })
            .store(in: self.cancelBag)
    }
}
