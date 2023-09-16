//
//  BaseSessionDelegate.swift
//  Network
//
//  Created by sejin on 2023/09/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Alamofire

class BaseSessionDelegate: SessionDelegate {
    // dev.sopt.org에 SSL 인증서 만료 문제가 있어서 이를 임시적으로 무시하고 서버 통신을 하기 위해 추가
    override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.host.contains("dev.sopt.org"){
           let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
           completionHandler(.useCredential, urlCredential)
       }else{
           completionHandler(.performDefaultHandling, nil)
       }
    }
}
