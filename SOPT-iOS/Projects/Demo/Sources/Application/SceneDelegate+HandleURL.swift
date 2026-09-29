//
//  SceneDelegate+HandleURL.swift
//  SOPT-iOS
//
//  Created by Junho Lee on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

// MARK: Handle URLs

extension SceneDelegate {
    func parseContexts(openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            print("url: \(context.url.absoluteURL)")
            print("scheme: \(String(describing: context.url.scheme))")
            print("host: \(String(describing: context.url.host))")
            print("path: \(context.url.path)")
            print("query: \(String(describing: context.url.query))")
            print("components: \(context.url.pathComponents)")
            
            guard let _url = URLContexts.first?.url,
                  context.url.host() ?? "" == URLHandler.makers else {
                return
            }
            handleURL(url: _url)
        }
    }
    
    private func handleURL(url: URL) {
        print("")
        print("==============================")
        print("URL Handling 시작")
        print("==============================")
        print("")
        
        let urlStr = url.absoluteString
        let components = URLComponents(string: urlStr)
        let schemeData = components?.scheme ?? ""
        let parameter = components?.query ?? ""
        
        print("")
        print("==============================")
        print("[Scheme 접속 및 파라미터 값 확인]")
        print("urlStr : ", urlStr)
        print("scheme : ", schemeData)
        print("query : ", parameter)
        print("==============================")
        print("")
                
        let purePath = url.pathComponents[safe: 1] ?? ""
        let handler = URLHandler.init(rawValue: purePath)
        switch handler {
        case .playgroundLogin:
            redirectSignInVC(url: urlStr)
        default: return
        }
    }
    
    func redirectSignInVC(url: String) {
        appCoordinator.start(with: .signInSuccess(url: url))
    }

    /// 유니버설 링크로 진입한 UserActivity를 처리합니다.
    /// 그 외 UserActivity(상태 복원 등)면 콜드 스타트일 때만 평소대로 앱을 시작합니다.
    func handleUniversalLinkWithUserActivity(_ userActivity: NSUserActivity, isInitialLaunch: Bool = false) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL else {
            if isInitialLaunch {
                appCoordinator.start()
            }
            return
        }

        let url = incomingURL.absoluteString
        if isInitialLaunch {
            appCoordinator.start(with: .universalWebLink(url: url))
        } else {
            // 이미 실행 중이면 코디네이터를 다시 시작하지 않고 링크만 흘려보냅니다.
            notificationHandler.receive(webLink: url)
        }
    }
}
