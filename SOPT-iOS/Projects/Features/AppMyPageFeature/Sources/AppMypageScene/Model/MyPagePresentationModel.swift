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
        let generation = historyList.last.map { "\($0)기" } ?? ""
        return MyPageProfilePresentationModel(name: name, part: generation, profileImageURL: profileImage)
    }
}

extension SoptlogModel {
    func toPresentation() -> MyPageSoptlogPreviewPresentationModel {
        MyPageSoptlogPreviewPresentationModel(soptampCount: soptampCount ?? 0, totalPokeCount: totalPokeCount)
    }
}
