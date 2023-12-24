//
//  MainVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine
import SnapKit
import Then

import BaseFeatureDependency

public class MainVC: UIViewController, MainViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: MainViewModel!
    private var cancelBag = CancelBag()
    
    private var requestUserInfo = PassthroughSubject<Void, Never>()
    private var cellTapped = PassthroughSubject<IndexPath, Never>()
    
    // MARK: - UI Components
    
    private lazy var naviBar = MainNavigationBar().hideNoticeButton(wantsToHide: self.viewModel.userType == .visitor)
    
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
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.registerCells()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestUserInfo.send()
    }
}

// MARK: - UI & Layout

extension MainVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.gray950.color
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
final class ComponentWorkplaceViewController: UIViewController {
    private lazy var stackView = UIStackView(frame: self.view.frame).then {
        $0.axis = .vertical
        $0.spacing = 10.f
    }
    
    private var cancelBag = CancelBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DSKitAsset.Colors.gray800.color
        
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.lessThanOrEqualTo(500.f)
        }
    }
}

extension MainVC {
    private func bindViewModels() {
      let noticeButtonTapped = naviBar.noticeButtonTap
            .mapVoid()
            .asDriver()
        
        let myPageButtonTapped = naviBar.rightButtonTap
            .mapVoid()
            .asDriver()
        
        let input = MainViewModel.Input(
            requestUserInfo: requestUserInfo.asDriver(),
            viewDidLoad: Just<Void>(()).asDriver(),
            noticeButtonTapped: noticeButtonTapped,
            myPageButtonTapped: myPageButtonTapped,
            cellTapped: cellTapped.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.needToReload
            .sink { [weak self] _ in
                guard let userMainInfo = self?.viewModel.userMainInfo else {
                    self?.collectionView.reloadData()
                    return
                }
                print("MainVC User 모델: \(userMainInfo)")
                self?.updateUI(with: userMainInfo)
            }.store(in: self.cancelBag)
        
        output.isServiceAvailable
            .sink { isServiceAvailable in
                print("현재 앱 서비스 사용 가능(심사 X)?: \(isServiceAvailable)")
            }.store(in: self.cancelBag)
        
        output.needNetworkAlert
            .sink { [weak self] in
                self?.presentNetworkAlertVC()
            }.store(in: self.cancelBag)
        
        output.isLoading
            .sink { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.stopLoading()
            }.store(in: self.cancelBag)
    }
    
    private func setDelegate() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCells() {
        self.collectionView.register(UserHistoryHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: UserHistoryHeaderView.className)
        self.collectionView.register(UserHistoryCVC.self, forCellWithReuseIdentifier: UserHistoryCVC.className)
        self.collectionView.register(MainServiceHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: MainServiceHeaderView.className)
        self.collectionView.register(MainServiceCVC.self, forCellWithReuseIdentifier: MainServiceCVC.className)
        self.collectionView.register(ProductCVC.self, forCellWithReuseIdentifier: ProductCVC.className)
        self.collectionView.register(AppServiceHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: AppServiceHeaderView.className)
        self.collectionView.register(AppServiceCVC.self, forCellWithReuseIdentifier: AppServiceCVC.className)
    }
    
    private func updateUI(with model: UserMainInfoModel) {
        if let isAllConfirm = model.isAllConfirm {
            self.naviBar.changeNoticeButtonStyle(isActive: !isAllConfirm)
        }
        
        self.naviBar.hideNoticeButton(wantsToHide: self.viewModel.userType == .visitor)
        self.collectionView.reloadData()
    }
    
    private func presentNetworkAlertVC() {
        guard self.presentedViewController == nil else { return }
        
        AlertUtils.presentAlertVC(
            type: .titleDescription,
            theme: .main,
            title: I18N.Default.networkError,
            description: I18N.Default.networkErrorDescription,
            customButtonTitle: I18N.Default.ok,
            customAction:{ [weak self] in
                self?.requestUserInfo.send()
            }
        )
    }
}

extension MainVC: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewControllers = self.navigationController?.viewControllers else { return false }
        return viewControllers.count > 1
    }
}

// MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTapped.send(indexPath)
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
        case 1:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: MainServiceHeaderView.className,
                                                  for: indexPath) as? MainServiceHeaderView
            else { return UICollectionReusableView() }
            headerView.initCell(title: viewModel.mainDescription.topDescription)
            return headerView
        case 3:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: AppServiceHeaderView.className,
                                                  for: indexPath) as? AppServiceHeaderView
            else { return UICollectionReusableView() }
            headerView.initCell(userType: viewModel.userType, title: viewModel.mainDescription.bottomDescription)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.mainServiceList.count
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
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainServiceCVC.className, for: indexPath) as? MainServiceCVC else { return UICollectionViewCell() }
                cell.initCell(serviceType: viewModel.mainServiceList[indexPath.item], userType: viewModel.userType)
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVC.className, for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
            cell.initCell(serviceType: viewModel.mainServiceList[indexPath.item], userType: viewModel.userType)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVC.className, for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
            cell.initCell(serviceType: viewModel.otherServiceList[indexPath.item], userType: viewModel.userType)
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
