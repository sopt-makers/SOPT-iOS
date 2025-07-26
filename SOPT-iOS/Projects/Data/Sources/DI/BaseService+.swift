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

extension BaseService {
    
    public static var standard: BaseService {
        
        @Injected var repository: AuthTokensRepositoryInterface
        
        return BaseService<Target>(
            interceptor: ReissueInterceptor(
                accessTokenClosure: { repository.fetch()?.accessToken },
                refreshClosure: repository.refresh
            )
        )
    }
}
