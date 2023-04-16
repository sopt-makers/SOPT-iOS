//
//  ExternalURL.swift
//  Core
//
//  Created by devxsby on 2023/01/01.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public struct ExternalURL {
    
    public struct AppStore {
        public static let appStoreLink = "https://itunes.apple.com/kr/app/id6444594319"
    }
    
    public struct GoogleForms {
        public static let serviceProposal = "https://forms.gle/L2HpRCvFMh9VvcA57"
        public static let findEmail = "https://forms.gle/XkVFMUPsWWV1DXU38"
    }
    
    public struct Playground {
        public static func login(state: String = "") -> String {
            return "https://sopt-internal-dev.pages.dev/auth/oauth?redirect_uri=sopt-makers://org.sopt.makers.iOS/oauth2redirect&state=\(state)"
        }
    }
}
