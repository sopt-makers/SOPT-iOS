//
//  OAuthProvider.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum OAuthProvider: String {
    case google
    case apple
    
    public var title: String {
        switch self {
        case .google: "Google"
        case .apple: "Apple"
        }
    }
}
