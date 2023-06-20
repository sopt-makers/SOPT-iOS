//
//  SceneDelegate+HandleURL.swift
//  SOPT-iOS
//
//  Created by Junho Lee on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import AuthFeature

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
        // FIXME: - Coordinator 이용한 방식으로 변경
        var signInControllable = AuthBuilder().makeSignIn().vc
        signInControllable.skipAnimation = true
        for item in parseParameter(url: url) {
            if item.query == "state" {
                signInControllable.requestState = item.value
                continue
            }
            
            if item.query == "code" {
                signInControllable.accessCode = item.value
                continue
            }
        }
        self.window?.rootViewController = signInControllable.viewController
        self.window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    func parseParameter(url: String) -> [(query: String, value: String)] {
        let components = URLComponents(string: url)
        let params = components?.query ?? ""
        guard params.count > 0 && params != "",
              let items = components?.queryItems else {
            return []
        }
        return items.map {
            ($0.name, $0.value ?? "")
        }
    }
}

