//
//  StampGuideVC.swift
//  Presentation
//
//  Created by devxsby on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import DSKit

import Domain

import Core

import SnapKit
import Then

import StampFeatureInterface

public class StampGuideVC: UIViewController, StampGuideViewControllable {
    
    // MARK: - Properties
    
    private var stampGuideData: [StampGuideDataModel] = []
    
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            startButton.setEnabled(currentPage == 2)
        }
    }
    
    // MARK: - UI Components
    
    private lazy var naviBar = STNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.StampGuide.guide)
    
    private lazy var stampGuideCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = DSKitAsset.Colors.soptampPurple200.color
        $0.currentPageIndicatorTintColor = DSKitAsset.Colors.soptampPurple300.color
        $0.numberOfPages = 3
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var startButton = STCustomButton(title: I18N.StampGuide.okay).setEnabled(false).then {
        $0.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setCollectionViewCell()
        self.setStampGuideData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - @objc Function
    
    @objc
    private func startButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UI & Layout

extension StampGuideVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.soptampWhite.color
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, stampGuideCollectionView, startButton,
                         pageControl)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        stampGuideCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(70.adjustedH)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(460.adjustedH)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(70.adjustedH)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(startButton).offset(-80.adjustedH)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension StampGuideVC {
    
    private func setCollectionViewCell() {
        stampGuideCollectionView.delegate = self
        stampGuideCollectionView.dataSource = self
        
        stampGuideCollectionView.register(StampGuideCVC.self, forCellWithReuseIdentifier: StampGuideCVC.className)
    }
    
    private func setStampGuideData() {
        stampGuideData.append(contentsOf: [
            StampGuideDataModel(image: DSKitAsset.Assets.splashImg1.image,
                                title: I18N.StampGuide.title1,
                                caption: I18N.StampGuide.caption1),
            StampGuideDataModel(image: DSKitAsset.Assets.splashImg2.image,
                                title: I18N.StampGuide.title2,
                                caption: I18N.StampGuide.caption2),
            StampGuideDataModel(image: DSKitAsset.Assets.splashImg3.image,
                                title: I18N.StampGuide.title3,
                                caption: I18N.StampGuide.caption3)
        ])
    }
}

// MARK: - CollectionView Delegate, DataSource

extension StampGuideVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stampGuideData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = stampGuideCollectionView.dequeueReusableCell(withReuseIdentifier: StampGuideCVC.className, for: indexPath) as? StampGuideCVC else { return UICollectionViewCell() }
        cell.setStampGuideSlides(stampGuideData[indexPath.row])
        return cell
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.view.frame.width)
        self.currentPage = page
    }
}

// MARK: - CollectionView DelegateFlowLayout

extension StampGuideVC: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = self.view.frame.size.width
        return CGSize(width: length, height: 460.adjustedH)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
