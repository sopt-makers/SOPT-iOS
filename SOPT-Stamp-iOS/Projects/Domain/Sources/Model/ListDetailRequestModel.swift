//
//  ListDetailRequestModel.swift
//  Domain
//
//  Created by 양수빈 on 2022/12/05.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public struct ListDetailRequestModel {
    let imgURL: UIImage
    let content: String
    
    public init(imgURL: UIImage, content: String) {
        self.imgURL = imgURL
        self.content = content
    }
}
