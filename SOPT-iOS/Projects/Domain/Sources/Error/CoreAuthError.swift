//
//  CoreAuthError.swift
//  Domain
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public enum CoreAuthError: Error {
    case apple(Apple)
    case google(Google)
    case makers(Makers)
    case unknown(Error)
    
    public enum Apple: Error {
        case authFail(Error)
        case credentialFail
        case encodedFail
    }
    
    public enum Google: Error {
        
    }
    
    public enum Makers: Error {
        case loginFail
    }
}
