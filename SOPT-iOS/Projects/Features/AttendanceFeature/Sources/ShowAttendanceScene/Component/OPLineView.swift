//
//  OPLineView.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/06/02.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import MDS

public enum LineType {
    case check
    case unCheck
    
    var color: UIColor {
        switch self {
        case .check:
            return SemanticColor.Fg.Neutral.bold
        case .unCheck:
            return SemanticColor.Fg.Neutral.subtle
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
