//
//  MissionListViewModelTests.swift
//  StampFeatureInterface
//
//  Created by Junho Lee on 2023/04/26.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

@testable import StampFeature

import Quick
import Nimble
import Combine

import Core
import Domain

final
class MissionListViewModelTests: QuickSpec {
    override func spec() {
        describe("MissionListViewModel") {
            var defaultViewModel: MissionListViewModel!
            var rankingViewModel: MissionListViewModel!
            var useCase: MockMissionListUseCase!
            var cancelBag: CancelBag!

            beforeEach {
                useCase = MockMissionListUseCase()
                defaultViewModel = MissionListViewModel(useCase: useCase, sceneType: .default)
                rankingViewModel = MissionListViewModel(useCase: useCase, sceneType: .ranking(
                    userName: "username", sentence: "sentence")
                )
                cancelBag = CancelBag()
            }

            afterEach {
                defaultViewModel = nil
                rankingViewModel = nil
                useCase = nil
                cancelBag = nil
            }

            context("defaultViewModel") {
                it("viewWillAppear에서 missionList가 fetch된다") {
                    // Given
                    let input = MissionListViewModel.Input(
                        viewWillAppear: .just(()),
                        missionTypeSelected: .init(MissionListFetchType.all)
                    )

                    // When
                    let _ = defaultViewModel.transform(from: input, cancelBag: cancelBag)

                    // Then
                    expect(useCase.fetchMissionListCalled).to(beTrue())
                    expect(useCase.fetchOtherUserMissionListCalled).to(beFalse())
                }

                it("typeSelected에서 missionList가 fetch된다") {
                    // Given
                    let input = MissionListViewModel.Input(
                        viewWillAppear: .empty(),
                        missionTypeSelected: .init(MissionListFetchType.all)
                    )

                    // When
                    let output = defaultViewModel.transform(from: input, cancelBag: cancelBag)
                    input.missionTypeSelected.send(.complete)

                    // Then
                    expect(useCase.fetchMissionListCalled).to(beTrue())
                    expect(useCase.fetchOtherUserMissionListCalled).to(beFalse())
                    expect(useCase.fetchType).to(equal(.complete))
                }
            }
            
            context("rankingViewModel") {
                it("viewWillAppear에서 otherMissionList가 fetch된다") {
                    // Given
                    let input = MissionListViewModel.Input(
                        viewWillAppear: .just(()),
                        missionTypeSelected: .init(MissionListFetchType.all)
                    )

                    // When
                    let _ = rankingViewModel.transform(from: input, cancelBag: cancelBag)

                    // Then
                    expect(useCase.fetchMissionListCalled).to(beFalse())
                    expect(useCase.fetchOtherUserMissionListCalled).to(beTrue())
                    expect(useCase.username).to(equal("username"))
                }

                it("typeSelected에서 otherMissionList가 fetch된다") {
                    // Given
                    let input = MissionListViewModel.Input(
                        viewWillAppear: .empty(),
                        missionTypeSelected: .init(MissionListFetchType.all)
                    )

                    // When
                    let output = rankingViewModel.transform(from: input, cancelBag: cancelBag)
                    input.missionTypeSelected.send(.complete)

                    // Then
                    expect(useCase.fetchMissionListCalled).to(beTrue())
                    expect(useCase.fetchOtherUserMissionListCalled).to(beFalse())
                }
            }
        }
    }
}
