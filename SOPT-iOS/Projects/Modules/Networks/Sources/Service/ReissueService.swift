//
//  ReissueService.swift
//  Networks
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public protocol LegacyReissueService {
    func reissuance(with tokens: AuthTokens, completion: @escaping ((SignInEntity?) -> Void))
}

public typealias DefaultLegacyReissueService = BaseService<LegacyReissueAPI>

extension DefaultLegacyReissueService: LegacyReissueService {

    @Sendable
    public func reissuance(with tokens: AuthTokens, completion: @escaping ((SignInEntity?) -> Void)) {
        
        provider.request(.reissuance(refreshToken: tokens.refreshToken)) { response in
            switch response {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(SignInEntity.self, from: value.data)
                    completion(body)
                } catch {
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }
    }
}
