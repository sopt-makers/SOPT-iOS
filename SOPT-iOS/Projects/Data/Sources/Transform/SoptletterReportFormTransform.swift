//
//  SoptletterReportFormTransform.swift
//  Data
//
//  Created by 강윤서 on 7/29/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Networks
import Domain

extension SoptletterReportFormResponse {
    func toDomain() -> SoptletterReportFormModel {
        SoptletterReportFormModel(reportFormUrl: reportFormUrl)
    }
}
