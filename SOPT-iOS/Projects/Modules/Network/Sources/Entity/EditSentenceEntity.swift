//
//  EditSentenceEntity.swift
//  Network
//
//  Created by Junho Lee on 2023/01/02.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

// MARK: - EditSentenceEntity
public struct EditSentenceEntity: Codable {
    let createdAt: String?
    let updatedAt: String
    let id: Int
    let nickname, email, password: String
    let clientToken: String?
    public let profileMessage: String
    let points: Int?
    let osType: String?
}
