//
//  AnnouncementPageContolFooterView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

final class AnnouncementPageContolFooterView: UICollectionViewCell {
    
    // MARK: - Properties

    private let cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let cardPageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.isUserInteractionEnabled = false
        $0.backgroundStyle = .minimal
        $0.currentPageIndicatorTintColor = DSKitAsset.Colors.white.color
        $0.pageIndicatorTintColor = DSKitAsset.Colors.gray300.color
        $0.hidesForSinglePage = true
        $0.transform = .init(scaleX: 0.7, y: 0.7)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AnnouncementPageContolFooterView {
    private func setLayout() {
        self.addSubview(cardPageControl)
        
        cardPageControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(-20)
        }
    }
}

// MARK: - Methods

extension AnnouncementPageContolFooterView {
    func bind(input: PassthroughSubject<Int, Never>, pageNumber: Int) {
        cardPageControl.numberOfPages = pageNumber
        input
            .withUnretained(self)
            .sink { owner, currentPage in
                owner.cardPageControl.currentPage = currentPage
            }.store(in: cancelBag)
    }
}
