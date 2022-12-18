//
//  SettingViewModel.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class SettingViewModel: ViewModelType {

    private let useCase: SettingUseCase
    private var cancelBag = CancelBag()
    public var sectionList: [String] = [I18N.Setting.myinfo,
                                        I18N.Setting.serviceUsagePolicy,
                                        I18N.Setting.mission,
                                        I18N.Setting.logout]
    public var settingList: [[String]] = [[I18N.Setting.bioEdit,
                                           I18N.Setting.passwordEdit,
                                           I18N.Setting.nicknameEdit],
                                          [I18N.Setting.personalInfoPolicy,
                                           I18N.Setting.serviceTerm,
                                           I18N.Setting.suggestion],
                                          [I18N.Setting.resetMission],
                                          [I18N.Setting.logout]
    ]
    
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
    }
    
    // MARK: - init
  
    public init(useCase: SettingUseCase) {
        self.useCase = useCase
    }
}

extension SettingViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
