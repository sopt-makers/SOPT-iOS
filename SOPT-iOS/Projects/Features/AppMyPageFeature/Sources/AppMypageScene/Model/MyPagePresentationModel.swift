//
//  MyPagePresentationModel.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 2026/07/04.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain

struct MyPageProfilePresentationModel {
    let name: String
    let part: String
    let profileImageURL: String?
}

struct MyPageSoptlogPreviewPresentationModel {
    let soptampCount: Int
    let totalPokeCount: Int
}

extension UserMainInfoModel {
    func toPresentation() -> MyPageProfilePresentationModel {
        // part는 API 미제공 필드라 우선 숨김 처리 (별도 이슈에서 연동 예정)
        MyPageProfilePresentationModel(name: name, part: "", profileImageURL: profileImage)
    }
}

extension SoptlogModel {
    func toPresentation() -> MyPageSoptlogPreviewPresentationModel {
        MyPageSoptlogPreviewPresentationModel(soptampCount: soptampCount ?? 0, totalPokeCount: totalPokeCount)
    }
}
