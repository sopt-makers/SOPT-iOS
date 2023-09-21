//
//  AppSwitchView.swift
//  DSKit
//
//  Created by Ian on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

public final class AppSwitchView: UISwitch {
    private enum Constant {
        static let tintColor = DSKitAsset.Colors.blue50.color
        static let disabledColor = DSKitAsset.Colors.gray80.color
    }
    
    public init(
        isEnabled: Bool = false,
        frame: CGRect
    ) {
        super.init(frame: frame)
        
        self.onTintColor = Constant.tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
