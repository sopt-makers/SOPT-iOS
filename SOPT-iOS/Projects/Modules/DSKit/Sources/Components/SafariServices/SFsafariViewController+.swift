//
//  SFsafariViewController+.swift
//  DSKit
//
//  Created by Junho Lee on 2023/04/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import SafariServices

public extension SFSafariViewController {
    func playgroundStyle() {
        preferredBarTintColor = .black
        preferredControlTintColor = .white
        dismissButtonStyle = .cancel
    }    
}
