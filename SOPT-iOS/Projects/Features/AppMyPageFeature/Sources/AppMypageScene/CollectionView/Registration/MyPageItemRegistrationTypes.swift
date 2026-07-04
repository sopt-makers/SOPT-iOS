//
//  MyPageItemRegistrationTypes.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

// cells
typealias MyPageCellRegistration = UICollectionView.CellRegistration<MyPageCVC, MyPageItem>
typealias MyPageProfileCellRegistration = UICollectionView.CellRegistration<MyPageProfileCVC, MyPageItem>
typealias MyPageSoptlogStatCellRegistration = UICollectionView.CellRegistration<MyPageSoptlogStatCVC, MyPageItem>
typealias MyPageSoptlogCheckButtonCellRegistration = UICollectionView.CellRegistration<MyPageSoptlogCheckButtonCVC, MyPageItem>

// supplementary views
typealias MyPageHeaderRegistration = UICollectionView.SupplementaryRegistration<MyPageSectionHeaderView>
