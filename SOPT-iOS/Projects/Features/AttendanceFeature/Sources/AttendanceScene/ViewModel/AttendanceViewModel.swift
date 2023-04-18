//
//  AttendanceViewModel.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class AttendanceViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: AttendanceUseCase
    private var cancelBag = CancelBag()
    
    private let (firstIdx, lastIdx) = (0, 4)
    private var codeText: String = ""
    
    // MARK: - Input
    
    public struct Input {
        let codeTextChanged: Driver<AttendanceCodeInfo>
    }
    
    // MARK: - Output
    
    public struct Output {
        let codeTextFieldInfo = PassthroughSubject<(AttendanceCodeInfo, AttendanceCodeInfo), Never>()
        let isAttendanceButtonEnabled = CurrentValueSubject<Bool, Never>(false)
    }
    
    public init(useCase: AttendanceUseCase) {
        self.useCase = useCase
    }
}

extension AttendanceViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.codeTextChanged
            .withUnretained(self)
            .sink { owner, code in
                let codeInfo = owner.updateCodeText(code)
                output.codeTextFieldInfo.send(codeInfo)
                output.isAttendanceButtonEnabled.send(owner.codeText.count == 5)
            }
            .store(in: self.cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        
    }
    
    private func updateCodeText(_ code: AttendanceCodeInfo) -> (AttendanceCodeInfo, AttendanceCodeInfo) {
        var (curCode, nxtCode) = (code, code)
        
        if let text = curCode.text {
            // 숫자 지워진 경우
            if text.isEmpty {
                if curCode.idx == firstIdx {
                    codeText = ""
                } else {
                    nxtCode.idx -= 1
                    codeText.removeLast()
                    nxtCode.text = String(codeText.last!)
                }
                return (curCode, nxtCode)
            }
            // 숫자 입력된 경우
            else {
                if curCode.idx == lastIdx {
                    nxtCode.text = String(codeText.last!)
                    return (curCode, nxtCode)
                } else {
                    if text.count == 2 {
                        nxtCode.idx += 1
                        curCode.text = String(text.first!)
                        nxtCode.text = String(text.last!)
                    }
                }
            }
        }
        
        codeText += nxtCode.text ?? ""
        
        return (curCode, nxtCode)
    }
}
