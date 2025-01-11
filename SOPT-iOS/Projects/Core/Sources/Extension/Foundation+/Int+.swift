//
//  Int+.swift
//  Core
//
//  Created by 장석우 on 1/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

extension Int {
    
    public var to_mmss: String {
//        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
