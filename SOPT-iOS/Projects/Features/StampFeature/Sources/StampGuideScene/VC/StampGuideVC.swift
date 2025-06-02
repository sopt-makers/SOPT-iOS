//
//  StampGuideVC.swift
//  Presentation
//
//  Created by devxsby on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit
import Domain

import SnapKit
import Then

import BaseFeatureDependency

public final class StampGuideVC: UIViewController, LegacyStampGuideViewControllable {
    
    // MARK: - Properties
    
    private var stampGuideData: [StampGuideDataModel] = []
    
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            startButton.setEnabled(currentPage == 2)
        }
    }
    
    public var onNaviBackTap: (() -> Void)?
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private lazy var naviBar = STNavigationBar(type: .titleWithLeftButton)
        .setTitle(I18N.StampGuide.guide)
    
    private lazy var stampGuideCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = DSKitAsset.Colors.gray950.color
        return collectionView
    }()
    
    private lazy var pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = DSKitAsset.Colors.gray500.color
        $0.currentPageIndicatorTintColor = DSKitAsset.Colors.white.color
        $0.numberOfPages = 3
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var startButton = STCustomButton(title: I18N.StampGuide.okay).then {
        $0.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        $0.setColor(
            bgColor: DSKitAsset.Colors.white.color,
            disableColor: DSKitAsset.Colors.gray800.color,
            textColor: DSKitAsset.Colors.black.color,
            disableTextcolor: DSKitAsset.Colors.gray300.color
        )
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setButtonDisabled()
        self.setCollectionViewCell()
        self.setStampGuideData()
        self.setObserver()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGestureDelegate()
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
        self.view.backgroundColor = DSKitAsset.Colors.gray950.color
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, stampGuideCollectionView, startButton,
                         pageControl)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        stampGuideCollectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-89)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(460)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(stampGuideCollectionView.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setButtonDisabled() {
        self.startButton.setEnabled(false)  // 초기 시작값 false
    }
}

// MARK: - Methods

extension StampGuideVC {
    private func setObserver() {
        self.naviBar.leftButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
    }
    
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
        return CGSize(width: length, height: 460)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UIGestureRecognizerDelegate

extension StampGuideVC: UIGestureRecognizerDelegate {
    private func setGestureDelegate() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
