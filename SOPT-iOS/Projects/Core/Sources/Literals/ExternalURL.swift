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
    
    public struct KakaoTalk {
        public static let serviceProposal = "https://pf.kakao.com/_sxaIWG"
    }
    
    public struct SOPT {
        public static let project = "https://sopt.org/project"
        public static let officialHomepage = "https://sopt.org"
        public static let review = "https://sopt.org/review"
        public static let faq = "https://sopt.org/FAQ"
    }
    
    public struct SNS {
        public static let youtube = "https://m.youtube.com/@SOPTMEDIA"
        public static let instagram = "https://www.instagram.com/sopt_official"
        
    }
    
    public struct Playground {
        #if DEV || PROD
        public static let main = "https://playground.sopt.org"
        #else
        public static let main = "https://sopt-internal-dev.pages.dev"
        #endif
        
        public static func login(state: String = "") -> String {
            return "\(main)/auth/oauth?redirect_uri=sopt-makers://org.sopt.makers.iOS/oauth2redirect&state=\(state)"
        }
        
        public static let project = "\(main)/projects"
        public static let member = "\(main)/members"
        public static let group = "\(main)/group?utm_source=playground_group&utm_medium=app_button&utm_campaign=app"
        public static let playgroundCommunity = main
    }
}
