//
//  AttendanceViewModel.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain

public final class AttendanceViewModel: ViewModelType {
    
    // MARK: - Properties
    
    public enum Constant {
        static let codeTextCount = 5
    }
    
    private let useCase: AttendanceUseCase
    private var cancelBag = CancelBag()
    
    private var lectureRound: AttendanceRoundModel = .EMPTY
    private var codeText: String = ""
    
    // MARK: - Input
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let codeTextChanged: Driver<AttendanceCodeInfo>
        let attendanceButtonDidTap: Driver<Void>
    }
    
    // MARK: - Output
    
    public struct Output {
        let attendanceTitle = PassthroughSubject<String, Never>()
        let codeTextFieldInfo = PassthroughSubject<(AttendanceCodeInfo, AttendanceCodeInfo), Never>()
        let isAttendanceButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        let attendSuccess = PassthroughSubject<Bool, Never>()
        let attendErrorMsg = PassthroughSubject<String, Never>()
    }
    
    public init(useCase: AttendanceUseCase, lectureRound: AttendanceRoundModel) {
        self.useCase = useCase
        self.lectureRound = lectureRound
    }
}

extension AttendanceViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        
        self.bindOutput(output: output, cancelBag: cancelBag)

        input.viewWillAppear
            .withUnretained(self)
            .sink { owner, _ in
                output.attendanceTitle.send(I18N.Attendance.nthAttendance(owner.lectureRound.round))
            }
            .store(in: self.cancelBag)
        
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
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { owner, _ in
                let lectureRoundId = owner.lectureRound.subLectureId
                let code = owner.codeText
                owner.useCase.postAttendance(lectureRoundId: lectureRoundId, code: code)
            }
            .store(in: self.cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let attendSuccess = self.useCase.attendSuccess
        let attendErrorMsg = self.useCase.attendErrorMsg
        
        attendSuccess.asDriver()
            .sink { isSuccess in
                output.attendSuccess.send(isSuccess)
            }
            .store(in: self.cancelBag)
        
        attendErrorMsg.asDriver()
            .withUnretained(self)
            .sink { owner, errorMsg in
                output.attendErrorMsg.send(errorMsg)
                output.isAttendanceButtonEnabled.send(false)
                owner.codeText = ""
            }
            .store(in: self.cancelBag)
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
