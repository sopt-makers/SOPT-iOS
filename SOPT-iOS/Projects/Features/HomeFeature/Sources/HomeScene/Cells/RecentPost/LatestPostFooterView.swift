//
//  LatestPostFooterView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 6/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit
import MDS

final class LatestPostFooterView: UICollectionReusableView {
    
    // MARK: - Properties

    private var cancelBag = CancelBag()
    private let currentPageSubject = CurrentValueSubject<Int, Never>(0)
    
    // MARK: - UI Components
    
    private let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.isUserInteractionEnabled = false
        $0.preferredIndicatorImage = DSKitAsset.Assets.imgIndicator.image
        $0.preferredCurrentPageIndicatorImage = DSKitAsset.Assets.imgIndicator.image
        $0.pageIndicatorTintColor = SemanticColor.Bg.Neutral.subtle
        $0.currentPageIndicatorTintColor = SemanticColor.Bg.Neutral.inverse
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
        cancelBag.cancel()
        cancelBag = CancelBag()
        bind()
    }
}

// MARK: - UI & Layout

extension LatestPostFooterView {
    private func setLayout() {
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension LatestPostFooterView {
    private func bind() {
        currentPageSubject
            .sink { [weak self] currentPage in
                guard let self else { return }
                self.pageControl.currentPage = currentPage
            }
            .store(in: cancelBag)
    }
    
    func configure(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    func updatePage(currentPage: Int) {
        currentPageSubject.send(currentPage)
    }
}
