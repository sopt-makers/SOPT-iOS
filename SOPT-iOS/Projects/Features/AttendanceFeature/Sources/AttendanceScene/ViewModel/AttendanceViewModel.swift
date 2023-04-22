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

public final class AttendanceViewModel: ViewModelType {
    
    // MARK: - Properties
    
    public enum Constant {
        static let codeTextCount = 5
    }
    
    private let useCase: AttendanceUseCase
    private var cancelBag = CancelBag()
    
    private var codeText: String = ""
    
    // MARK: - Input
    
    public struct Input {
        let codeTextChanged: Driver<AttendanceCodeInfo>
        let attendanceButtonDidTap: Driver<Void>
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
        
        input.attendanceButtonDidTap
            .withUnretained(self)
            .sink { owner, _ in
                #warning("차수 서버값 넘겨주기")
                let code = Int(owner.codeText) ?? 0
                owner.useCase.postAttendance(lectureRoundId: 0, code: code)
            }
            .store(in: self.cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        
    }
    
    private func updateCodeText(_ code: AttendanceCodeInfo) -> (AttendanceCodeInfo, AttendanceCodeInfo) {
        var (curCode, nxtCode) = (code, code)
        
        guard let text = curCode.text else {
            return (curCode, nxtCode)
        }
        
        /// 숫자 제거
        if text.isEmpty {
            /// 지울 숫자가 있는 경우
            if !codeText.isEmpty {
                nxtCode.idx -= 1
                codeText.removeLast()
                nxtCode.text = codeText.getLast()
            }
            return (curCode, nxtCode)
        }
        /// 숫자 입력
        else {
            /// 전부 입력된 경우
            if codeText.count >= Constant.codeTextCount {
                nxtCode.text = codeText.getLast()
                return (curCode, nxtCode)
            }
            /// 숫자 다음칸으로 이동
            else if text.count == 2 {
                curCode.text = text.getFirst()
                
                nxtCode.idx += 1
                nxtCode.text = text.getLast()
            }
        }
        
        codeText += nxtCode.text ?? ""
        
        return (curCode, nxtCode)
    }
}
