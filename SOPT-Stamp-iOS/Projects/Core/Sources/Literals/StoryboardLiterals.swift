//
//  StoryboardLiterals.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public enum Storyboards: String {
    case sample = "Sample"
}

extension UIStoryboard{
    static func list(_ name : Storyboards) -> UIStoryboard{
        return UIStoryboard(name: name.rawValue, bundle: nil)
    }
}

