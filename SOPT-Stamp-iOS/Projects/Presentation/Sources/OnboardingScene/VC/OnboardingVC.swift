//
//  OnboardingVC.swift
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

public class OnboardingVC: UIViewController {
    
    // MARK: - Properties
    
    private var onboardingData: [OnboardingDataModel] = []
    
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            startButton.setEnabled(currentPage == 2)
        }
    }
    
    public var factory: ModuleFactoryInterface!
  
    // MARK: - UI Components
    
    private lazy var onboardingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = DSKitAsset.Colors.purple200.color
        $0.currentPageIndicatorTintColor = DSKitAsset.Colors.purple300.color
        $0.numberOfPages = 3
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var startButton = CustomButton(title: I18N.Onboarding.start).setEnabled(false).then {
        $0.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }

    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setCollectionViewCell()
        self.setOnboardingData()
    }

    // MARK: - @objc Function
    
    @objc
    private func startButtonDidTap() {
        print("start btn did tap")
    }
}

// MARK: - UI & Layout

extension OnboardingVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.white.color
    }
    
    private func setLayout() {
        view.addSubviews(onboardingCollectionView, pageControl, startButton)
        
        onboardingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40.adjustedH)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(450.adjusted)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(onboardingCollectionView.snp.bottom).offset(14.adjustedH)
            make.centerX.equalToSuperview()
        }
    
        startButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(50.adjustedH)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
            make.height.equalTo(56)
        }
    }
}

// MARK: - Methods

extension OnboardingVC {
    
    private func setCollectionViewCell() {
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        
        onboardingCollectionView.register(OnboardingCVC.self, forCellWithReuseIdentifier: OnboardingCVC.className)
    }
    
    private func setOnboardingData() {
        onboardingData.append(contentsOf: [
            OnboardingDataModel(image: DSKitAsset.Assets.splashImg1.image,
                                title: I18N.Onboarding.title1,
                                caption: I18N.Onboarding.caption1),
            OnboardingDataModel(image: DSKitAsset.Assets.splashImg2.image,
                                title: I18N.Onboarding.title2,
                                caption: I18N.Onboarding.caption2),
            OnboardingDataModel(image: DSKitAsset.Assets.splashImg3.image,
                                title: I18N.Onboarding.title3,
                                caption: I18N.Onboarding.caption3)
        ])
    }
}

// MARK: - CollectionView Delegate, DataSource

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = onboardingCollectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCVC.className, for: indexPath) as? OnboardingCVC else { return UICollectionViewCell() }
        cell.setOnboardingSlides(onboardingData[indexPath.row])
        return cell
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.view.frame.width)
        self.currentPage = page
    }
}

// MARK: - CollectionView DelegateFlowLayout

extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = self.view.frame.size.width
        return CGSize(width: length, height: 450.adjustedH)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
