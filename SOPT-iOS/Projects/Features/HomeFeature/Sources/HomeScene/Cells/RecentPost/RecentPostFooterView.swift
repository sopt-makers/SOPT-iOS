//
//  RecentPostFooterView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 6/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

final class RecentPostFooterView: UICollectionReusableView {
    
    // MARK: - Properties

    private var cancelBag = CancelBag()
    private let currentPageSubject = CurrentValueSubject<Int, Never>(0)
    
    // MARK: - UI Components
    
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = DSKitAsset.Colors.white.color
        $0.numberOfPages = 5
        $0.currentPage = 0
        $0.isUserInteractionEnabled = false
        $0.preferredIndicatorImage = DSKitAsset.Assets.imgIndicator.image
        $0.preferredCurrentPageIndicatorImage = DSKitAsset.Assets.imgIndicator.image
        $0.pageIndicatorTintColor = DSKitAsset.Colors.gray700.color
        $0.currentPageIndicatorTintColor = DSKitAsset.Colors.gray50.color
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelBag = CancelBag()
        bind()
    }
}

// MARK: - UI & Layout

extension RecentPostFooterView {
    private func setLayout() {
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension RecentPostFooterView {
    private func bind() {
        currentPageSubject
            .sink { [weak self] currentPage in
                guard let self else { return }
                self.pageControl.currentPage = currentPage
            }
            .store(in: cancelBag)
    }
    
    func updatePage(currentPage: Int) {
        currentPageSubject.send(currentPage)
    }
}
