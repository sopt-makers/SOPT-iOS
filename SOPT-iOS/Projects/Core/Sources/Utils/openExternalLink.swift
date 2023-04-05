//
//  openExternalLink.swift
//  Core
//
//  Created by devxsby on 2023/01/02.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public func openExternalLink(urlStr: String, _ handler: (() -> Void)? = nil) {
    guard let url = URL(string: urlStr) else {
        return
    }
    
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:]) { _ in
            handler?()
        }
    } else {
        UIApplication.shared.openURL(url)
        handler?()
    }
}
