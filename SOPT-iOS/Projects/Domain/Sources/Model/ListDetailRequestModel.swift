//
//  ListDetailRequestModel.swift
//  Domain
//
//  Created by 양수빈 on 2022/12/05.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public struct ListDetailRequestModel {
    public let imgURL: Data?
    public let content: String
    
    public init(imgURL: Data, content: String) {
        self.imgURL = imgURL
        self.content = content
    }
}
