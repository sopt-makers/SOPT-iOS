//
//  ListDetailTransform.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

extension ListDetailEntity {
    public func toDomain() -> ListDetailModel {
        // TODO: - date 형식 확인하고 변형
        return ListDetailModel.init(image: self.images.first ?? "",
                                    content: self.contents,
                                    date: self.updatedAt ?? self.createdAt)
    }
}
