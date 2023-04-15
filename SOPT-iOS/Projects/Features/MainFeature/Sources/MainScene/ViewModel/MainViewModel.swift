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

public class MainViewModel: ViewModelType {

    // MARK: - Properties
    
    private let useCase: MainUseCase
    private var cancelBag = CancelBag()
    
    var userType: UserType = .visitor
    var mainServiceList: [ServiceType] = [.officialHomepage, .review, .project]
    var otherServiceList: [ServiceType] = [.faq, .youtube]
    var appServiceList: [AppServiceType] = [.soptamp]
    var userMainInfo: UserMainInfoModel?
  
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var getUserMainInfoDidComplete = PassthroughSubject<Void, Never>()
    }
    
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
        
        input.viewDidLoad
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.useCase.getUserMainInfo()
            }.store(in: cancelBag)
    
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.userMainInfo.asDriver()
            .sink { [weak self] userMainInfo in
                self?.userMainInfo = userMainInfo
                output.getUserMainInfoDidComplete.send()
            }.store(in: self.cancelBag)
    }
    
    /// 메인 뷰에 보여줄 카드들 종류 설정
    private func setServiceList(with userType: UserType) {
        switch userType {
        case .visitor:
            self.mainServiceList = [.officialHomepage, .review, .project]
            self.otherServiceList = [.faq, .youtube]
        case .active:
            self.mainServiceList = [.attendance, .member, .project]
            self.otherServiceList = [.officialHomepage, .crew]
        case .inactive:
            self.mainServiceList = [.faq, .member, .project]
            self.otherServiceList = [.crew, .officialHomepage]
        }
    }
    
    func calculateMonths() -> String? {
        guard let userMainInfo = userMainInfo else { return nil }
        if userMainInfo.status == "ACTIVE" && userMainInfo.historyList.count > 0 {
            guard var currentMonth = getCurrentMonth() else {
                return String(userMainInfo.historyList.count * 5)
            }

            // 짝수 기수 -> 상반기
            if let recent = userMainInfo.historyList.first {
                var currentGenerationTime = 0
                if recent % 2 == 0 {
                    // 기수 시작 3월 기준으로 계산
                    currentGenerationTime = currentMonth - 3 + 1
                } else {
                    // 현재 1월 일 때
                    if currentMonth < 3 {
                        currentMonth += 12
                    }
                    currentGenerationTime = currentMonth - 9 + 1
                }
                return String((userMainInfo.historyList.count-1)*5 + currentGenerationTime)
            }
        }
        return String(userMainInfo.historyList.count * 5)
    }
    
    private func getCurrentMonth() -> Int? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        let monthString = dateFormatter.string(from: date)
        return Int(monthString)
    }
}
