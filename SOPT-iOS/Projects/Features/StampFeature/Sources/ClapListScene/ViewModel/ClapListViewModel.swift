//
//  ClapListViewModel.swift
//  StampFeature
//
//  Created by 성현주 on 10/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine
import Foundation

import Core
import Domain
import BaseFeatureDependency

final class ClapListViewModel: ClapListViewModelType {

    // MARK: - Triggers
    var onNaviBackTap: (() -> Void)?
    var onCellTap: ((String?) -> Void)?

    // MARK: - Properties
    private var cancelBag = CancelBag()

    // MARK: - Input

    struct Input {
        let viewDidLoad: Driver<Void>
        let viewWillAppear: Driver<Void>
    }

    // MARK: - Output
    final class Output: NSObject {
        @Published var clapListModel: [ClapListModel]?
    }

    // MARK: - Init
    init() {}
}

extension ClapListViewModel {

    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()

        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.loadDummyData(to: output)
            }.store(in: cancelBag)

        input.viewWillAppear
            .withUnretained(self)
            .sink { owner, _ in
                owner.loadDummyData(to: output)
            }.store(in: cancelBag)

        return output
    }

    private func loadDummyData(to output: Output) {
        let dummyData = [
            ClapListModel(name: "서버황혜린", subtitle: "최대글자수최대글자수최대글자수", clapCount: 50),
            ClapListModel(name: "서버황혜린", subtitle: "최대글자수최대글자수최대글자수", clapCount: 50),
            ClapListModel(name: "서버황혜린", subtitle: "최대글자수최대글자수최대글자수", clapCount: 50),
            ClapListModel(name: "서버황혜린", subtitle: "최대글자수최대글자수최대글자수", clapCount: 50)
        ]
        output.clapListModel = dummyData
    }
}

