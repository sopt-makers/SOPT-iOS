//
//  OPLineView.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/06/02.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

public enum LineType {
    case check
    case unCheck
    
    var color: UIColor {
        switch self {
        case .check:
            return DSKitAsset.Colors.gray10.color
        case .unCheck:
            return DSKitAsset.Colors.gray400.color
        }
    }
}

final class OPLineView: UIView {
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = LineType.unCheck.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI

extension OPLineView {
    func setColor(type: LineType) {
        backgroundColor = type.color
    }
}
