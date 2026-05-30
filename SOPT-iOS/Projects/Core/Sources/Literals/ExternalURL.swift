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
        public static let notionApp = "https://apps.apple.com/app/notion-notes-docs-tasks/id1232780281"
        public static let naverMapApp = "https://apps.apple.com/app/naver-maps-navigation/id311867728"
    }
    
    public struct KakaoTalk {
        public static let serviceProposal = "https://pf.kakao.com/_sxaIWG"
    }
    
    public struct SOPT {
        public static let project = "https://sopt.org/project"
        public static let officialHomepage = "https://sopt.org"
        public static let review = "https://sopt.org/review"
        public static let faq = "https://sopt.org/FAQ"
        public static let memberVerifyGoogleForm = "https://docs.google.com/forms/d/e/1FAIpQLSdBxksqlkAHShYdQYxDIK1Mnsy45MbYMkEeGuCMpeXjn6C1NQ/viewform"
    }
    
    public struct SNS {
        public static let youtube = "https://m.youtube.com/@SOPTMEDIA"
        public static let instagram = "https://www.instagram.com/sopt_official"
        
    }
    
    public struct Playground {
        #if DEV || PROD
        public static let main = "https://playground.sopt.org"
        #else
        public static let main = "https://sopt-internal-dev.sopt.org"
        #endif
        
        public static func login(state: String = "") -> String {
            return "\(main)/auth/oauth?redirect_uri=sopt-makers://org.sopt.makers.iOS/oauth2redirect&state=\(state)"
        }
        
        public static let project = "\(main)/projects"
        public static let member = "\(main)/members"
        public static let group = "\(main)/group?utm_source=playground_group&utm_medium=app_button&utm_campaign=app"
        public static let feedUpload = "\(main)/feed/upload"
        public static let feed = "\(main)/feed"
        public static let blog = "\(main)/blog"
        public static let makeGroup = "\(main)/group/make"
        public static let makeLightGroup = "\(main)/group/make/flash"
        public static let makeGroupFeed = "\(main)/group?modal=create-feed"
        public static let editProfile = "\(main)/members/edit"
        public static let coffeechat = "\(main)/coffeechat"
    }
}
