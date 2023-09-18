//
//  OPCodeTextField.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

@frozen
public enum AttendanceCodeState {
    case empty
    case fill
    
    var backgroundColor: UIColor {
        switch self {
        case .empty:
            return DSKitAsset.Colors.black60.color
        case .fill:
            return DSKitAsset.Colors.black80.color
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .empty:
            return DSKitAsset.Colors.black60.color.cgColor
        case .fill:
            return DSKitAsset.Colors.gray40.color.cgColor
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
    
    public func updateUI(text: String?) {
        let state: AttendanceCodeState = (text == "") ? .empty : .fill
        
        backgroundColor = state.backgroundColor
        layer.borderColor = state.borderColor
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
        
        textColor = DSKitAsset.Colors.gray40.color
        font = .Main.headline2
        textAlignment = .center
        tintColor = .clear
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = AttendanceCodeState.empty.borderColor
        
        keyboardType = .numberPad
        textContentType = .oneTimeCode
    }
}
