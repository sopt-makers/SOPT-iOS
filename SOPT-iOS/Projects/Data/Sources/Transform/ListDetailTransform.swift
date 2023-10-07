//
//  ListDetailTransform.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension ListDetailEntity {
    public func toDomain() -> ListDetailModel {
        
        return ListDetailModel.init(image: self.images.first ?? "",
                                    content: self.contents,
                                    date: changeDateformat(self.updatedAt ?? self.createdAt),
                                    stampId: self.id)
    }
    
    private func changeDateformat(_ date: String) -> String {
        return date.split(separator: "-").joined(separator: ".")
    }
}

extension StampEntity {
    public func toDomain() -> Int {
        return self.stampId
    }
}
