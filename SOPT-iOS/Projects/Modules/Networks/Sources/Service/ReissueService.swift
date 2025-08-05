//
//  ReissueService.swift
//  Networks
//
//  Created by 장석우 on 7/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public protocol ReissueService {
    func reissuance(with tokens: AuthTokens, completion: @escaping ((AuthTokens?) -> Void))
}

public final class DefaultLegacyReissueService: BaseService<LegacyReissueAPI> { }

extension DefaultLegacyReissueService: ReissueService {

    @Sendable
    public func reissuance(with tokens: AuthTokens, completion: @escaping ((AuthTokens?) -> Void)) {
        
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

public final class DefaultReissueService: BaseService<ReissueAPI> { }

extension DefaultReissueService: ReissueService {

    @Sendable
    public func reissuance(with tokens: AuthTokens, completion: @escaping ((AuthTokens?) -> Void)) {
        
        provider.request(.reissue(tokens)) { response in
            switch response {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(BaseEntity<AuthTokensEntity>.self, from: value.data)
                    completion(body.data)
                } catch {
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }
    }
}
