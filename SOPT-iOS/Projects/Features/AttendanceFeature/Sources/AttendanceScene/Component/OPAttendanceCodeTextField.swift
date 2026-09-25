//
//  OPCodeTextField.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

@frozen
public enum AttendanceCodeState {
    case empty
    case fill
    case error
    
    var backgroundColor: UIColor {
        switch self {
        case .empty, .fill:
            return SemanticColor.Bg.Neutral.subtle
        case .error:
            return SemanticColor.Bg.Neutral.ghost
        }
    }
    
    var strokeColor: UIColor {
        switch self {
        case .empty:
            return SemanticColor.Stroke.Neutral.default
        case .fill:
            return SemanticColor.Fg.Neutral.bold
        case .error:
            return SemanticColor.Stroke.Danger.default
        }
    }
}

/// 숫자코드 입력 자리수, 숫자
public struct AttendanceCodeInfo {
    var idx: Int
    var text: String?
}

final class OPAttendanceCodeTextField: UITextField {
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension OPAttendanceCodeTextField {
    
    public var textChanged: Driver<AttendanceCodeInfo> {
        self.publisher(for: .editingChanged)
            .map { _ in
                AttendanceCodeInfo(
                    idx: self.tag,
                    text: self.text
                )
            }
            .asDriver()
    }
    
    public func updateUI(text: String?, isError: Bool = false) {
        let state: AttendanceCodeState = isError ? .error : ((text == "") ? .empty : .fill)
        
        backgroundColor = state.backgroundColor
        layer.borderColor = state.strokeColor.cgColor
        
        self.text = text
    }
    
    ///  복사 붙여넣기 방지
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}


// MARK: - UI

extension OPAttendanceCodeTextField {
    private func setUI() {
        backgroundColor = AttendanceCodeState.empty.backgroundColor
        
        textColor = SemanticColor.Fg.Neutral.bold
        // TODO: - 적용 후 변경
        font = .Main.headline2
        textAlignment = .center
        tintColor = .clear
        
        layer.cornerRadius = BaseRadius.Base.r10
        layer.borderWidth = 1
        layer.borderColor = AttendanceCodeState.empty.strokeColor.cgColor
        
        keyboardType = .numberPad
        textContentType = .oneTimeCode
    }
}
