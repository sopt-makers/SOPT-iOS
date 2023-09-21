//
//  MainViewModelTests.swift
//  MainFeatureTests
//
//  Created by sejin on 2023/07/05.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

@testable import MainFeature

import Quick
import Nimble
import Combine

import Core
import Domain

final class MainViewModelTests: QuickSpec {
    override func spec() {
        describe("MainViewModel 테스트") {
            var viewModel: MainViewModel!
            var useCase: MockMainUseCase!
            let userType: UserType = .active
            var cancelBag: CancelBag!
            
            beforeEach {
                useCase = MockMainUseCase()
                viewModel = MainViewModel(useCase: useCase, userType: userType)
                cancelBag = CancelBag()
            }
            
            afterEach {
                viewModel = nil
                useCase = nil
                cancelBag = nil
            }
            
            context("ViewWillAppear에서 UserInfo 요청") {
                it("userModel을 가져온다.") {
                    let requestUserInfo = PassthroughSubject<Void, Never>()
                    let input = MainViewModel.Input(requestUserInfo: requestUserInfo.asDriver(),
                                                    noticeButtonTapped: .empty(),
                                                    myPageButtonTapped: .empty(),
                                                    cellTapped: .empty())
                    
                    let output = viewModel.transform(from: input, cancelBag: cancelBag)
                    
                    var result: Void? = nil

                    output.needToReload
                        .sink { completion in
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                fail("Error: \(error)")
                            }
                        } receiveValue: { value in
                            result = value
                        }.store(in: cancelBag)
                    
                    requestUserInfo.send(())
                    
                    expect(viewModel.userMainInfo).toEventually(equal(UserMainInfoModel.dummyUserInfoModel[0]))
                    expect(result).toEventually(beVoid())
                }
            }
            
            context("SOPT 가입일로부터 현재까지의 기간(월) 계산") {
                let userInfoModel = UserMainInfoModel.dummyUserInfoModel
                
                it("userInfoModel이 nil이기 때문에 월 계산도 nil을 반환한다.") {
                    let months = viewModel.calculateMonths()
                    expect(months).to(beNil())
                }

                it("사용자의 32기부터 현재까지의 기간이 계산된다.") {
                    viewModel.userMainInfo = userInfoModel[0]
                    let months = viewModel.calculateMonths()!
                    expect(months).to(equal("5"))
                }
                
                it("사용자의 31기부터 현재까지의 기간이 계산된다.") {
                    viewModel.userMainInfo = userInfoModel[1]
                    let months = viewModel.calculateMonths()!
                    expect(months).to(equal("23"))
                }
            }
        }
    }
}

extension UserMainInfoModel {
   static var dummyUserInfoModel: [UserMainInfoModel] {
        return [UserMainInfoModel(status: "ACTIVE",
                                 name: "김솝트",
                                 profileImage: nil,
                                 historyList: [32],
                                 attendanceScore: 2.0,
                                 announcement: nil),
                UserMainInfoModel(status: "INACTIVE",
                                         name: "이솝트",
                                         profileImage: nil,
                                         historyList: [32, 29],
                                         attendanceScore: 2.0,
                                         announcement: nil),
                ]
    }
}
