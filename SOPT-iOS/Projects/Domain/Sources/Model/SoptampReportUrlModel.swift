//
//  SoptampReportURLModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 10/14/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - SoptampReportURLModel

public struct SoptampReportUrlModel: Codable {
    public let reportUrl: String
    
    public init(reportUrl: String) {
        self.reportUrl = reportUrl
    }
}
