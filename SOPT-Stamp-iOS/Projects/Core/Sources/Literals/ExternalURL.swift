//
//  ExternalURL.swift
//  Core
//
//  Created by devxsby on 2023/01/01.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public struct ExternalURL {
    
    public struct GoogleForms {
        
        public static let findEmail = "https://forms.gle/XkVFMUPsWWV1DXU38"
        public static let findPassword = "https://forms.gle/bUgTG9ooRVgPZ8K39"
    }
    
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
}
