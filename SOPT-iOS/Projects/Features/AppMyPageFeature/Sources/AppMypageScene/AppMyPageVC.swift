//
//  AppMyPageVC.swift
//  AppMypageFeature
//
//  Created by Ian on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine
import SafariServices
import SnapKit
import Then

import Core
import DSKit
import BaseFeatureDependency

public final class AppMyPageVC: UIViewController, MyPageViewControllable {

    // MARK: - Properties

    private let viewModel: AppMyPageViewModel
    private let userType: UserType
    // TODO: 앱잼탬프 오픈 여부 API 연동 (별도 이슈에서 진행 예정)
    private let isAppjamtampOpen: Bool = false
    private var dataSource: UICollectionViewDiffableDataSource<MyPageSectionLayoutKind, MyPageItem>! = nil
    private var cellTapped = PassthroughSubject<MyPageItem, Never>()
    private var refreshTriggered = PassthroughSubject<Void, Never>()
    private let cancelBag = CancelBag()

    private var userProfileData: MyPageProfilePresentationModel?
    private var soptlogData: MyPageSoptlogPreviewPresentationModel?

    // MARK: - UI Components

    private lazy var navigationBar = OPNavigationBar(
        self,
        type: .none,
        backgroundColor: DSKitAsset.Colors.black100.color,
        ignoreLeftButtonAction: true
    )
        .addMiddleLabel(title: I18N.MyPage.title)

    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.contentInset.bottom = 36 // 마지막 섹션 자체 bottom inset(32) + 36 = 탭바까지 68pt
    }

    private let refreshControl = UIRefreshControl()

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setRegister()
        setDataSource()
        applySnapshot()
        bindViewModels()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    public init(userType: UserType, viewModel: AppMyPageViewModel) {
        self.userType = userType
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppMyPageVC {
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }

    private func setLayout() {
        view.addSubviews(navigationBar, collectionView)

        navigationBar.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(13)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setRegister() {
        collectionView.collectionViewLayout.register(MyPageSectionBackgroundView.self, forDecorationViewOfKind: MyPageSectionBackgroundView.className)
        collectionView.collectionViewLayout.register(MyPageSoptlogPreviewBackgroundView.self, forDecorationViewOfKind: MyPageSoptlogPreviewBackgroundView.className)
        collectionView.register(MyPageSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyPageSectionHeaderView.className)
    }

    private func setDataSource() {
        let myPageMenuRegistration = createMyPageeCellRegistration()

        let profileRegistration: MyPageProfileCellRegistration = collectionView.createCellRegistration { [weak self] cell, _, item in
            guard let self else { return }
            cell.configure(
                name: self.userProfileData?.name ?? "",
                part: self.userProfileData?.part ?? "",
                profileImageURL: self.userProfileData?.profileImageURL
            )
            cell.onEditProfileTap = { [weak self] in
                self?.cellTapped.send(item)
            }
        }

        let soptlogStatRegistration: MyPageSoptlogStatCellRegistration = collectionView.createCellRegistration { [weak self] cell, _, item in
            guard let self else { return }
            switch item.type {
            case .soptlogSoptampPreview:
                cell.configure(icon: DSKitAsset.Assets.icThumb.image, iconSize: 21, title: I18N.Soptlog.soptamp, count: self.soptlogData?.soptampCount ?? 0)
            case .soptlogPokePreview:
                cell.configure(icon: DSKitAsset.Assets.icPokeFilled.image.withRenderingMode(.alwaysTemplate), iconSize: 24, title: I18N.Soptlog.poke, count: self.soptlogData?.totalPokeCount ?? 0)
            default:
                break
            }
        }

        let soptlogCheckButtonRegistration: MyPageSoptlogCheckButtonCellRegistration = collectionView.createCellRegistration { cell, _, item in
            cell.configureCell(model: item)
        }

        dataSource = UICollectionViewDiffableDataSource<MyPageSectionLayoutKind, MyPageItem>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item.type {
            case .profileCard:
                return collectionView.dequeueConfiguredReusableCell(using: profileRegistration, for: indexPath, item: item)
            case .soptlogSoptampPreview, .soptlogPokePreview:
                return collectionView.dequeueConfiguredReusableCell(using: soptlogStatRegistration, for: indexPath, item: item)
            case .soptlogCheckButton:
                return collectionView.dequeueConfiguredReusableCell(using: soptlogCheckButtonRegistration, for: indexPath, item: item)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: myPageMenuRegistration, for: indexPath, item: item)
            }
        }

        configureSupplementaryView()
    }

    private func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration()

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }

            return UICollectionReusableView()
        }
    }

    private func makeSections(for userType: UserType) -> [MyPageSectionLayoutKind] {
        switch userType {
        case .visitor:
            return [.servicePolicy, .etcVisitor]
        default:
            return [.profile, .soptlogPreview, .soptlogCheckButton, .servicePolicy, .notificationSettings, .soptampSettings, .etcUser]
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MyPageSectionLayoutKind, MyPageItem>()

        let sections = makeSections(for: self.userType)
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items(userType: self.userType, isAppjamtampOpen: isAppjamtampOpen), toSection: section)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension AppMyPageVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath), item.type != .profileCard else { return }
        cellTapped.send(item)
    }
}

// MARK: - Methods

extension AppMyPageVC {
    private func bindViewModels() {
        let input = AppMyPageViewModel.Input(
            viewDidLoad: Driver.just(()),
            naviBackButtonTapped: navigationBar.leftButtonTapped.asDriver(),
            cellTapped: cellTapped.asDriver(),
            refreshTriggered: refreshTriggered.asDriver()
        )

        let output = viewModel.transform(from: input, cancelBag: cancelBag)

        output.resetSuccessed
            .filter { $0 }
            .withUnretained(self)
            .sink { owner, _ in
                Toast.show(message: I18N.MyPage.resetSuccess, view: owner.view)
            }.store(in: self.cancelBag)

        output.userProfile
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, profile in
                owner.userProfileData = profile
                owner.reconfigureItems(in: .profile)
            }.store(in: cancelBag)

        output.soptlogPreview
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, soptlog in
                owner.soptlogData = soptlog
                owner.reconfigureItems(in: .soptlogPreview)
            }.store(in: cancelBag)

        output.fetchError
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, _ in
                Toast.show(message: I18N.MyPage.fetchErrorToast, view: owner.view)
            }.store(in: cancelBag)

        output.fetchCompleted
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, _ in
                owner.refreshControl.endRefreshing()
            }.store(in: cancelBag)
    }

    @objc private func handleRefresh() {
        refreshTriggered.send()
    }

    private func reconfigureItems(in section: MyPageSectionLayoutKind) {
        var snapshot = dataSource.snapshot()
        guard snapshot.sectionIdentifiers.contains(section) else { return }
        snapshot.reconfigureItems(snapshot.itemIdentifiers(inSection: section))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
