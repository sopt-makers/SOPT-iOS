//
//  ClapListVC.swift
//  StampFeature
//
//  Created by 성현주 on 10/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine
import SnapKit
import Then

final class ClapListVC: UIViewController, ClapListViewControllable {

    // MARK: - Properties

    private var cancelBag = CancelBag()
    private var viewModel: ClapListViewModel
    lazy var dataSource: UICollectionViewDiffableDataSource<ClapListSection, ClapListModel>! = nil

    // MARK: - ClapListCoordinatable

    public var onNaviBackTap: (() -> Void)?
    public var onCellTap: ((String?) -> Void)?

    // MARK: - UI Components

    private lazy var naviBar = STNavigationBar(type: .titleWithLeftButton)
        .setTitle("박수 목록")
        .setTitleTypoStyle(.SoptampFont.h2)
        .setRightButton(.none)

    private lazy var clapListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createLayout()
    ).then {
        $0.backgroundColor = DSKitAsset.Colors.gray950.color
        $0.showsVerticalScrollIndicator = true
        $0.delegate = self
    }

    private let clapListEmptyView = UILabel().then {
        $0.text = "아직 받은 박수가 없어요 👏"
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.font = .SoptampFont.subtitle1
        $0.textAlignment = .center
        $0.isHidden = true
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.registerCells()
        self.setDataSource()
        self.bindViews()
        self.bindViewModel()
    }

    // MARK: - Init

    init(viewModel: ClapListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension ClapListVC {

    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.gray950.color
        navigationController?.isNavigationBarHidden = true
    }

    private func setLayout() {
        view.addSubviews(naviBar, clapListCollectionView, clapListEmptyView)

        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        clapListCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        clapListEmptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Bindings

extension ClapListVC {

    private func bindViews() {
        naviBar.leftButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }
            .store(in: cancelBag)
    }

    private func bindViewModel() {
        let input = ClapListViewModel.Input(
            viewDidLoad: Driver.just(()),
            viewWillAppear: Driver.just(())
        )

        let output = viewModel.transform(from: input, cancelBag: cancelBag)

        output.$clapListModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.setCollectionView(model: model)
            }
            .store(in: cancelBag)
    }
}

// MARK: - CollectionView

extension ClapListVC {

    private func registerCells() {
        ClapListCVC.register(target: clapListCollectionView)
    }

    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: clapListCollectionView
        ) { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ClapListCVC.className,
                for: indexPath
            ) as? ClapListCVC else {
                return UICollectionViewCell()
            }
            cell.setData(model: model)
            return cell
        }
    }

    func setCollectionView(model: [ClapListModel]) {
        if model.isEmpty {
            self.clapListCollectionView.isHidden = true
            self.clapListEmptyView.isHidden = false
            self.setEmptyView()
        } else {
            self.clapListCollectionView.isHidden = false
            self.clapListEmptyView.isHidden = true
            self.applySnapshot(model: model)
        }
    }

    private func setEmptyView() {
        clapListEmptyView.snp.removeConstraints()
        clapListEmptyView.removeFromSuperview()
        self.view.addSubview(clapListEmptyView)
        clapListEmptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    private func applySnapshot(model: [ClapListModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<ClapListSection, ClapListModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(model)
        dataSource.apply(snapshot, animatingDifferences: false)
        self.view.setNeedsLayout()
    }
}

// MARK: - Section Enum

enum ClapListSection: CaseIterable {
    case main
}

// MARK: - UICollectionViewDelegate

extension ClapListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource.itemIdentifier(for: indexPath) else { return }
        onCellTap?(model.name)
    }
}
