//
//  Config.swift
//  Network
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct Config {
    public enum Network {
        public static var baseURL: String {
            #if DEV || PROD
            return "https://app.sopt.org/api/v2"
            #else
            return "https://app.dev.sopt.org/api/v2"
            #endif
        }
        
        public static var operationBaseURL: String {
            #if DEV || PROD
            return "https://operation.api.sopt.org/api/v1/app"
            #else
            return "https://operation.api.dev.sopt.org/api/v1/app"
            #endif
        }
    }
    
    public enum Sentry {
        public static var DSN: String {
            return "https://8e5bc82b47204253bd0c129c04401c77@o4504849177247744.ingest.sentry.io/4505090751332352"
        }
    }
    
    public enum Amplitude {
        public static var apiKey: String {
            #if DEV || PROD
            return "4272511f23d1466bd8c597653c2666e4"
            #else
            return "c9ede2bebdb0c524972dc232fbf62f73"
            #endif
        }
    }
}
