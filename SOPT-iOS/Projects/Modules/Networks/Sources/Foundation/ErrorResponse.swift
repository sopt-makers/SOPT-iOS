//
//  ErrorResponse.swift
//  Networks
//
//  Created by sejin on 12/26/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ErrorResponse: Decodable, Equatable {
    public let statusCode: String
    public let responseMessage: String
}
