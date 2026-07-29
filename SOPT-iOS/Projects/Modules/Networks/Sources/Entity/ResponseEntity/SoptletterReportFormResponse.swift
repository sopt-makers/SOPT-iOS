//
//  SoptletterReportFormResponse.swift
//  Networks
//
//  Created by 강윤서 on 7/29/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterReportFormResponse: Codable {
    public let reportFormUrl: String

    public init(reportFormUrl: String) {
        self.reportFormUrl = reportFormUrl
    }
}
