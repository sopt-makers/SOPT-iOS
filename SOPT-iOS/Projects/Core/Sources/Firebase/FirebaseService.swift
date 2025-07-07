//
//  FirebaseService.swift
//  Core
//
//  Created by 강윤서 on 7/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import FirebaseCore

public final class Firebase {}

protocol FirebaseServicable {
    static func configure()
}

extension Firebase: FirebaseServicable {
    public static func configure() {
        FirebaseApp.configure()
    }
}
