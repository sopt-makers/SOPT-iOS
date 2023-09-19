//
//  MainViewModel.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import MainFeatureInterface

import Sentry

public class MainViewModel: MainViewModelType {

    // MARK: - Properties
    
    private let useCase: MainUseCase
    private var cancelBag = CancelBag()
    
    var userType: UserType = .visitor
    var mainServiceList: [ServiceType] = [.officialHomepage, .review, .project]
    var otherServiceList: [ServiceType] = [.instagram, .youtube, .faq]
    var appServiceList: [AppServiceType] = [.soptamp]
    var userMainInfo: UserMainInfoModel?
  
    // MARK: - Inputs
    
    public struct Input {
        let requestUserInfo: Driver<Void>
        let noticeButtonTapped: Driver<Void>
        let myPageButtonTapped: Driver<Void>
        let cellTapped: Driver<IndexPath>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var getUserMainInfoDidComplete = PassthroughSubject<Void, Never>()
        var isServiceAvailable = PassthroughSubject<Bool, Never>()
        var needNetworkAlert = PassthroughSubject<Void, Never>()
        var isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - MainCoordinatable
    
    public var onNoticeButtonTap: (() -> Void)?
    public var onMyPageButtonTap: ((UserType) -> Void)?
    public var onSafari: ((String) -> Void)?
    public var onAttendance: (() -> Void)?
    public var onSoptamp: (() -> Void)?
    public var onNeedSignIn: (() -> Void)?
    
    // MARK: - init
  
    public init(useCase: MainUseCase, userType: UserType) {
        self.useCase = useCase
        self.userType = userType
        setServiceList(with: userType)
    }
}

// MARK: - Methods

extension MainViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.noticeButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.onNoticeButtonTap?()
            }.store(in: cancelBag)
        
        input.myPageButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.onMyPageButtonTap?(self.userType)
            }.store(in: cancelBag)
        
        input.cellTapped
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                self.bindCellAction(indexPath)
            }.store(in: cancelBag)
        
        input.requestUserInfo
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.userType != .visitor {
                    output.isLoading.send(true)
                    self.useCase.getUserMainInfo()
                    self.useCase.getServiceState()
                }
            }.store(in: cancelBag)
    
        return output
    }

    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.userMainInfo
            .sink { [weak self] userMainInfo in
                guard let self = self else { return }
                guard let userMainInfo = userMainInfo else {
                    SentrySDK.capture(message: "메인 뷰 조회 실패")
                    output.needNetworkAlert.send()
                    return
                }
                self.userMainInfo = userMainInfo
                self.userType = userMainInfo.userType
                self.setServiceList(with: self.userType)
                self.setSentryUser()
                output.getUserMainInfoDidComplete.send()
            }.store(in: self.cancelBag)
        
        useCase.serviceState
            .sink { serviceState in
                output.isServiceAvailable.send(serviceState.isAvailable)
            }.store(in: self.cancelBag)
        
        // 모든 API 통신 완료되면 로딩뷰 숨기기
        Publishers.Zip(useCase.userMainInfo, useCase.serviceState)
            .sink { _ in
                output.isLoading.send(false)
            }.store(in: self.cancelBag)
        
        useCase.mainErrorOccurred
            .sink { [weak self] error in
                guard let self else { return }
                output.isLoading.send(false)
                SentrySDK.capture(error: error)
                switch error {
                case .networkError:
                    output.needNetworkAlert.send()
                case .authFailed:
                    self.onNeedSignIn?()
                }
            }.store(in: self.cancelBag)
    }
    
    private func bindCellAction(_ indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, _): break
        case (1, _):
            guard let service = mainServiceList[safe: indexPath.item] else { return }
            
            guard service != .attendance else {
                onAttendance?()
                return
            }
            
            let needOfficialProject = service == .project && userType == .visitor
            let serviceDomainURL = needOfficialProject
            ? ExternalURL.SOPT.project
            : service.serviceDomainLink
            onSafari?(serviceDomainURL)
            
        case (2, _):
            guard let service = otherServiceList[safe: indexPath.item] else { return }
            
            onSafari?(service.serviceDomainLink)
        case(3, _):
            guard userType != .visitor else { return }
            
            onSoptamp?()
        default: break
        }
    }
    
    /// 메인 뷰에 보여줄 카드들 종류 설정
    private func setServiceList(with userType: UserType) {
        switch userType {
        case .visitor:
            self.mainServiceList = [.officialHomepage, .review, .project]
            self.otherServiceList = [.instagram, .youtube, .faq]
        case .active:
            self.mainServiceList = [.attendance, .group, .member]
            self.otherServiceList = [.project, .officialHomepage]
        case .inactive:
            self.mainServiceList = [.group, .member, .project]
            self.otherServiceList = [.officialHomepage, .instagram, .youtube]
        }
    }
    
    /// 최초 솝트 가입일로부터 몇달이 지났는지 계산
    func calculateMonths() -> String? {
        guard let userMainInfo = userMainInfo, let firstHistory = userMainInfo.historyList.last else { return nil }
        guard let joinDate = calculateJoinDateWithFirstHistory(history: firstHistory), let monthDifference = calculateMonthDifference(since: joinDate) else { return nil }
        
        return String(monthDifference)
    }
    
    // 파라미터로 넣은 기수의 시작 날짜를 리턴
    private func calculateJoinDateWithFirstHistory(history: Int) -> Date? {
        let yearDifference = history / 2
        let month = (history % 2 == 0) ? 3 : 9 // 짝수 기수는 3월, 홀수 기수는 9월 시작
        // 1기를 2007년으로 계산
        return Date.from(year: yearDifference + 2007, month: month, day: 1)
    }

    // 파라미터로 넣은 날짜로 부터 현재 몇달이 지났는지 계산
    private func calculateMonthDifference(since startDate: Date) -> Int? {
        let calendar = Calendar.current

        let components = calendar.dateComponents([.month], from: startDate, to: .now)
        guard let month = components.month else {
            return nil
        }
        
        return month >= 0 ? month + 1 : nil
    }
}

extension MainViewModel {
    private func setSentryUser() {
        let user = User(
            userId: "\(self.userType.rawValue)_\(userMainInfo?.name ?? "비회원")"
        )
        user.data = ["accessToken": UserDefaultKeyList.Auth.appAccessToken ?? "EmptyAppAccessToken"]
        SentrySDK.setUser(user)
    }
}
