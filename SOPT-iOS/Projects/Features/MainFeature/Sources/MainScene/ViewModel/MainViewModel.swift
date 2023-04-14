//
//  MainViewModel.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

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
    var appServiceList: [AppServiceType] = [.soptamp, .soptamp, .soptamp, .soptamp, .soptamp, .soptamp]
    var briefNotice: String = ""
  
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
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
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
    
    private func setServiceList(with userType: UserType) {
        switch userType {
        case .visitor:
            self.mainServiceList = [.officialHomepage, .review, .project]
            self.otherServiceList = [.faq, .youtube]
        case .active:
            self.mainServiceList = [.attendance, .member, .project]
            self.otherServiceList = [.notice, .crew]
        case .inactive:
            self.mainServiceList = [.notice, .member, .project]
            self.otherServiceList = [.crew, .officialHomepage]
        }
    }
}
