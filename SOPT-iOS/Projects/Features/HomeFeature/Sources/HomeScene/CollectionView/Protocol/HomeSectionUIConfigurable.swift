//
//  HomeSectionUIConfigurable.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

protocol HomeSectionUIConfigurable {
    var headerTitle: String { get }
    var shouldShowFireIcon: Bool { get }
    var shouldShowViewAllContentButton: Bool { get }
    var isSubSectionHeader: Bool { get }
}

extension HomeSectionUIConfigurable {
    var isSubSectionHeader: Bool { return false }
}
