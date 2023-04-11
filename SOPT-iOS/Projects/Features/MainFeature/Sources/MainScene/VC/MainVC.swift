//
//  MainVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import MainFeatureInterface
import StampFeatureInterface
import SettingFeatureInterface

public class MainVC: UIViewController, MainViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: MainViewModel!
    public var factory: (StampFeatureViewBuildable & SettingFeatureViewBuildable)!
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let naviBar = MainNavigationBar()
    
    private lazy var collectionView: UICollectionView = {
      let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
      cv.isScrollEnabled = true
      cv.showsHorizontalScrollIndicator = false
      cv.showsVerticalScrollIndicator = false
      cv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
      cv.backgroundColor = .clear
      return cv
    }()
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.bindViews()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.registerCells()
    }
}

// MARK: - UI & Layout

extension MainVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, collectionView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension MainVC {
    private func bindViewModels() {
        let input = MainViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
    private func bindViews() {
        // FIXME: - 디버깅을 위한 임시 바인딩
        naviBar.myPageButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                owner.pushSettingFeature()
            }.store(in: self.cancelBag)
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCells() {
        self.collectionView.register(UserHistoryHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: UserHistoryHeaderView.className)
        self.collectionView.register(UserHistoryCVC.self, forCellWithReuseIdentifier: UserHistoryCVC.className)
        self.collectionView.register(BriefNoticeCVC.self, forCellWithReuseIdentifier: BriefNoticeCVC.className)
        self.collectionView.register(MainServiceCVC.self, forCellWithReuseIdentifier: MainServiceCVC.className)
        self.collectionView.register(AppServiceHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: AppServiceHeaderView.className)
        self.collectionView.register(AppServiceCVC.self, forCellWithReuseIdentifier: AppServiceCVC.className)
    }
    
    private func pushSoptampFeature() {
        let vc = factory.makeMissionListVC(sceneType: .default).viewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushSettingFeature() {
        let vc = factory.makeSettingVC().viewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - 디버깅을 위한 임시 솝탬프 피쳐 연결
        if indexPath.section == 3 {
            pushSoptampFeature()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        switch indexPath.section {
        case 0:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: UserHistoryHeaderView.className,
                                                  for: indexPath) as? UserHistoryHeaderView
            else { return UICollectionReusableView() }
            headerView.initCell(userType: viewModel.userType, name: "이솝트", days: "1234")
            return headerView
        case 3:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: AppServiceHeaderView.className,
                                                  for: indexPath) as? AppServiceHeaderView
            else { return UICollectionReusableView() }
            headerView.initCell(userType: viewModel.userType)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.mainServiceList.count + 1 // 상단 한줄 공지 Cell을 위해 +1
        case 2: return viewModel.otherServiceList.count
        case 3: return viewModel.appServiceList.count
        default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserHistoryCVC.className,
                                                                for: indexPath) as? UserHistoryCVC
            else { return UICollectionViewCell() }
            cell.initCell(userType: viewModel.userType, recentHistory: 32, allHistory: [31, 30, 29, 28, 27, 26, 25])
            return cell
        case 1:
            if indexPath.item == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BriefNoticeCVC.className,
                                                                    for: indexPath) as? BriefNoticeCVC
                else { return UICollectionViewCell() }
                cell.initCell(userType: viewModel.userType, text: viewModel.briefNotice)
                return cell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainServiceCVC.className, for: indexPath) as? MainServiceCVC else { return UICollectionViewCell() }
            cell.initCell(serviceType: viewModel.mainServiceList[indexPath.item-1], isMainFirstService: indexPath.item==1, isOtherService: false)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainServiceCVC.className, for: indexPath) as? MainServiceCVC else { return UICollectionViewCell() }
            cell.initCell(serviceType: viewModel.otherServiceList[indexPath.item], isMainFirstService: false, isOtherService: true)
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppServiceCVC.className, for: indexPath) as? AppServiceCVC else { return UICollectionViewCell() }
            cell.initCell(serviceType: viewModel.appServiceList[indexPath.item])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainServiceCVC.className, for: indexPath) as? MainServiceCVC else { return UICollectionViewCell() }
            return cell
        }
    }
}
