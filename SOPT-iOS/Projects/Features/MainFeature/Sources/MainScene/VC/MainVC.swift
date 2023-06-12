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
import BaseFeatureDependency
import MainFeatureInterface
import StampFeatureInterface
import SettingFeatureInterface
import AppMyPageFeatureInterface
import AttendanceFeatureInterface
import NotificationFeatureInterface

public class MainVC: UIViewController, MainViewControllable {
    public typealias factoryType = AuthFeatureViewBuildable
    & StampFeatureViewBuildable
    & SettingFeatureViewBuildable
    & AppMyPageFeatureViewBuildable
    & AttendanceFeatureViewBuildable
    & NotificationFeatureViewBuildable
    & AlertViewBuildable
    
    // MARK: - Properties
    
    public var viewModel: MainViewModel!
    public var factory: factoryType!
    private var cancelBag = CancelBag()
    
    private var requestUserInfo = PassthroughSubject<Void, Never>()

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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestUserInfo.send(())
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
            make.top.equalTo(naviBar.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension MainVC {
    private func bindViewModels() {
        let input = MainViewModel.Input(requestUserInfo: self.requestUserInfo)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.getUserMainInfoDidComplete
            .sink { [weak self] _ in
                guard let userMainInfo = self?.viewModel.userMainInfo else {
                    self?.collectionView.reloadData()
                    return
                }
                print("MainVC User 모델: \(userMainInfo)")
                self?.collectionView.reloadData()
            }.store(in: self.cancelBag)
   
        output.isServiceAvailable
            .sink { isServiceAvailable in
                print("현재 앱 서비스 사용 가능(심사 X)?: \(isServiceAvailable)")
            }.store(in: self.cancelBag)
        
        // 플그 프로필 미등록 유저 알림
        output.needPlaygroundProfileRegistration
            .sink { [weak self] in
                self?.presentPlaygroundRegisterationAlertVC()
            }.store(in: self.cancelBag)
        
        output.needNetworkAlert
            .sink { [weak self] in
                self?.presentNetworkAlertVC()
            }.store(in: self.cancelBag)
        
        output.needSignIn
            .sink { [weak self] in
                self?.setRootViewToSignIn()
            }.store(in: self.cancelBag)
        
        output.isLoading
            .sink { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.stopLoading()
            }.store(in: self.cancelBag)
    }
    
    private func bindViews() {
        naviBar.noticeButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                let notificationListVC = owner.factory.makeNotificationListVC().viewController
                owner.navigationController?.pushViewController(notificationListVC, animated: true)
            }.store(in: self.cancelBag)
        
        naviBar.rightButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                let viewController = owner.factory.makeAppMyPageVC(userType: owner.viewModel.userType).viewController
                owner.navigationController?.pushViewController(viewController, animated: true)
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
        guard let window = self.view.window else { return }
        let navigation = UINavigationController(rootViewController: factory.makeSignInVC().viewController)
        navigation.isNavigationBarHidden = true
        ViewControllerUtils.setRootViewController(window: window, viewController: navigation, withAnimation: true)
    }
    
    private func presentNetworkAlertVC() {
        guard self.presentedViewController == nil else { return }
        
        let networkAlertVC = factory.makeAlertVC(
            type: .titleDescription,
            theme: .main,
            title: I18N.Default.networkError,
            description: I18N.Default.networkErrorDescription,
            customButtonTitle: I18N.Default.ok,
            customAction:{ [weak self] in
                self?.requestUserInfo.send()
            }).viewController
        
        self.present(networkAlertVC, animated: false)
    }
    
    private func presentPlaygroundRegisterationAlertVC() {
        let alertVC = self.factory.makeAlertVC(
            type: .networkErr,
            theme: .main,
            title: I18N.Main.failedToGetUserInfo,
            description: I18N.Main.needToRegisterPlayground,
            customButtonTitle: "",
            customAction: nil)
            .viewController
        
        self.present(alertVC, animated: false)
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
          
          let needOfficialProject = service == .project && viewModel.userType == .visitor
          let serviceDomainURL = needOfficialProject
          ? ExternalURL.SOPT.project
          : service.serviceDomainLink
          showSafariVC(url: serviceDomainURL)
      case (2, _):
          guard let service = viewModel.otherServiceList[safe: indexPath.item] else { return }
          
          showSafariVC(url: service.serviceDomainLink)
      case(3, _):
          guard viewModel.userType != .visitor && viewModel.userType != .unregisteredInactive else { return }
          
          presentSoptampFeature()
      default: break
      }
    }
    
    private func showSafariVC(url: String) {
        let safariViewController = SFSafariViewController(url: URL(string: url)!)
        safariViewController.playgroundStyle()
        self.present(safariViewController, animated: true)
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
