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
    var shouldShowFireIcon: Bool { get } // fire 아이콘의 유무
    var shouldShowViewAllButton: Bool { get } // 전체보기 버튼의 유무
}
