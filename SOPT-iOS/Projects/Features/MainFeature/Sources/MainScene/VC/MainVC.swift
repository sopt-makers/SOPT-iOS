//
//  MainVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import SafariServices

import Core
import Domain
import DSKit

import Combine
import SnapKit
import Then

import AuthFeatureInterface
import MainFeatureInterface
import StampFeatureInterface
import SettingFeatureInterface
import AppMyPageFeatureInterface
import AttendanceFeatureInterface

public class MainVC: UIViewController, MainViewControllable {
    public typealias factoryType = AuthFeatureViewBuildable
    & StampFeatureViewBuildable
    & SettingFeatureViewBuildable
    & AppMyPageFeatureViewBuildable
    & AttendanceFeatureViewBuildable
    
    // MARK: - Properties
    
    public var viewModel: MainViewModel!
    public var factory: factoryType!
    private var cancelBag = CancelBag()
    
    private var userMainInfo: UserMainInfoModel?
    
    // MARK: - UI Components
    
    private let naviBar = MainNavigationBar()
    
    private lazy var collectionView: UICollectionView = {
      let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
      cv.isScrollEnabled = true
      cv.showsHorizontalScrollIndicator = false
      cv.showsVerticalScrollIndicator = false
      cv.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
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
        
        if viewModel.userType == .visitor {
            self.naviBar.setRightButtonImage(image: DSKitAsset.Assets.btnLogout.image)
        }
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, collectionView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension MainVC {
    private func bindViewModels() {
        let input = MainViewModel.Input(viewDidLoad: Driver.just(()))
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.getUserMainInfoDidComplete
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: self.cancelBag)
        
        output.isServiceAvailable
            .sink { [weak self] isServiceAvailable in
                print("현재 앱 서비스 사용 가능(심사 X)?: \(isServiceAvailable)")
            }.store(in: self.cancelBag)
    }
    
    private func bindViews() {
        // FIXME: - 디버깅을 위한 임시 바인딩
        naviBar.rightButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                let viewController = owner.factory.makeAppMyPageVC(userType: owner.viewModel.userType).viewController
                owner.navigationController?.pushViewController(viewController, animated: true)
              
//                if owner.viewModel.userType == .visitor {
//                    owner.setRootViewToSignIn()
//                    return
//                }
//                owner.pushSettingFeature()
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
    
    private func presentSoptampFeature() {
        let vc = factory.makeMissionListVC(sceneType: .default).viewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    private func pushSettingFeature() {
        let vc = factory.makeSettingVC().viewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setRootViewToSignIn() {
        let navigation = UINavigationController(rootViewController: factory.makeSignInVC().viewController)
        ViewControllerUtils.setRootViewController(window: self.view.window!, viewController: navigation, withAnimation: true)
    }
}

// MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      switch (indexPath.section, indexPath.row) {
      case (0, _): break
      case (1, _):
          guard let service = viewModel.mainServiceList[safe: indexPath.item - 1] else { return }
          
          guard service != .attendance else {
              let viewController = factory.makeShowAttendanceVC().viewController
              self.navigationController?.pushViewController(viewController, animated: true)
              return
          }

          let safariViewController = SFSafariViewController(url: URL(string: service.serviceDomainLink)!)
          self.present(safariViewController, animated: true)
  
      case (2, _):
          guard let service = viewModel.otherServiceList[safe: indexPath.item] else { return }
          
          let safariViewController = SFSafariViewController(url: URL(string: service.serviceDomainLink)!)
          self.present(safariViewController, animated: true)
      case(3, _):
          guard viewModel.userType != .visitor else { return }
          
          presentSoptampFeature()
      default: break
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
            headerView.initCell(userType: viewModel.userType, name: viewModel.userMainInfo?.name, months: viewModel.calculateMonths())
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
            cell.initCell(userType: viewModel.userType,
                          recentHistory: viewModel.userMainInfo?.historyList.first,
                          allHistory: viewModel.userMainInfo?.historyList)
            return cell
        case 1:
            if indexPath.item == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BriefNoticeCVC.className,
                                                                    for: indexPath) as? BriefNoticeCVC
                else { return UICollectionViewCell() }
                cell.initCell(userType: viewModel.userType, text: viewModel.userMainInfo?.announcement ?? "")
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
