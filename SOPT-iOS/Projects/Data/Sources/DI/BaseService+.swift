//
//  BaseService+.swift
//  Data
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks
import Moya

extension BaseService {
    
    public static var standard: BaseService {
        
        @Injected var repository: AuthTokensRepositoryInterface
        
        return BaseService<Target>(
            plugins: [
                AccessTokenPlugin(tokenClosure: { _ in
                    repository.fetch()?.accessToken ?? ""
                })
                ,Moya.NetworkLoggerPlugin.verbose
            ],
            interceptor: ReissueInterceptor(
                refreshClosure: repository.refresh
            )
        )
    }
}
