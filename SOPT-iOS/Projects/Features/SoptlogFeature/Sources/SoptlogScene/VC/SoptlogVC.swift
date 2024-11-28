//
//  SoptlogVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import BaseFeatureDependency

final class SoptlogVC: UIViewController, SoptlogViewControllable {
    
    // MARK: - Properties

    public let viewModel: SoptlogViewModel
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .clear
    }
    
    // MARK: - Initialization
    
    public init(viewModel: SoptlogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
    }
}

// MARK: - UI & Layout

extension SoptlogVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        view.addSubviews(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension SoptlogVC {
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCells() {
        self.collectionView.register(SoptlogHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: SoptlogHeaderView.className)
        self.collectionView.register(IntroduceCVC.self,
                                     forCellWithReuseIdentifier: IntroduceCVC.className)
        self.collectionView.register(SoptlogAppServiceCVC.self,
                                     forCellWithReuseIdentifier: SoptlogAppServiceCVC.className)
        self.collectionView.register(EditProfileCVC.self,
                                     forCellWithReuseIdentifier: EditProfileCVC.className)
        self.collectionView.register(SoptlogAlarmCVC.self,
                                     forCellWithReuseIdentifier: SoptlogAlarmCVC.className)
    }
}

// MARK: - UICollectionViewDelegate

extension SoptlogVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension SoptlogVC: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SoptlogSectionLayoutKind.allCases.count
    }
        
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        guard let sectionKind = SoptlogSectionLayoutKind(rawValue: indexPath.section) else { return UICollectionReusableView() }
        
        switch sectionKind {
        case .introduce:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SoptlogHeaderView.className,
                for: indexPath) as? SoptlogHeaderView else { return UICollectionReusableView() }
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionKind = SoptlogSectionLayoutKind(rawValue: section) else { return 0 }
        
        switch sectionKind {
        case .introduce: return 1
        case .appService: return 3
        case .editProfile: return 1
        case .alarm: return 1
        default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionKind = SoptlogSectionLayoutKind(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionKind {
        case .introduce:
            /// 한 줄 소개
            guard let introduceCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: IntroduceCVC.className,
                for: indexPath) as? IntroduceCVC else { return UICollectionViewCell() }
            return introduceCell
            
        case .appService:
            /// 앱 서비스
//            let productIndex = indexPath.item
            guard let appServiceCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SoptlogAppServiceCVC.className,
                for: indexPath) as? SoptlogAppServiceCVC else { return UICollectionViewCell() }
//            productCardCell.configureCell(title: viewModel.productInfoList[productIndex].name,
//                                          image: viewModel.productInfoList[productIndex].image)
            return appServiceCell
            
        case .editProfile:
            /// 프로필 수정
            guard let editProfileCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EditProfileCVC.className,
                for: indexPath) as? EditProfileCVC else { return UICollectionViewCell() }
            return editProfileCell
            
        case .alarm:
            /// 솝트로그 알람
            guard let alarmCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SoptlogAlarmCVC.className,
                for: indexPath) as? SoptlogAlarmCVC else { return UICollectionViewCell() }
            return alarmCell
            
        default: return UICollectionViewCell()
        }
    }
}
