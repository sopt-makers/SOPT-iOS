//
//  AppJamRankingViewModel.swift
//  StampFeature
//
//  Created by 강윤서 on 12/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import StampFeatureInterface

public class AppJamRankingViewModel: AppJamRankingViewModelType {

    // MARK: - Properties

    private let useCase: AppjamRankingUseCase
    private var cancelBag = CancelBag()
    private var fetchTask: Task<Void, Never>?

    // MARK: - Inputs

    public struct Input {
        let viewWillAppear: Driver<Void>
        let refreshStarted: Driver<Void>
        let naviBackButtonTapped: Driver<Void>
    }

    // MARK: - Outputs

    public class Output {
        let isLoading = PassthroughSubject<Bool, Never>()
        @Published var todayRankingList = [AppJamRankTodayPresentationModel]()
        @Published var recentMissionList = [AppJamRankRecentPresentationModel]()
    }

    // MARK: - AppJamCoordinatable

    public var onNaviBackTap: (() -> Void)?

    // MARK: - init

    public init(useCase: AppjamRankingUseCase) {
        self.useCase = useCase
    }

    deinit {
        fetchTask?.cancel()
    }
}

extension AppJamRankingViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()

        input.viewWillAppear.merge(with: input.refreshStarted)
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchTask?.cancel()
                output.isLoading.send(true)
                owner.fetchTask = Task { [weak owner] in
                    await owner?.fetchRankingData(output: output)
                }
            }.store(in: cancelBag)

        input.naviBackButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)

        return output
    }

    @MainActor
    private func fetchRankingData(output: Output) async {
        async let todayTask = fetchTodayRanking()
        async let recentTask = fetchRecentMissions()

        do {
            let (todayRanking, recentMissions) = try await (todayTask, recentTask)
            output.todayRankingList = todayRanking.map { AppJamRankTodayPresentationModel(from: $0) }
            output.recentMissionList = recentMissions.map { AppJamRankRecentPresentationModel(from: $0) }
            output.isLoading.send(false)
        } catch {
            print("AppJamRankingViewModel fetch error: \(error)")
            output.isLoading.send(false)
        }
    }

    private func fetchTodayRanking() async throws -> [Domain.AppjamRankTodayModel] {
        try await useCase.fetchTodayRanking(size: 10)
    }

    private func fetchRecentMissions() async throws -> [Domain.AppjamRankRecentModel] {
        try await useCase.fetchRecentRanking(size: 3)
    }
}
