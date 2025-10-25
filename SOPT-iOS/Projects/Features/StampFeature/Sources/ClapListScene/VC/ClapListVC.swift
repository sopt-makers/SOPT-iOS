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

    private let backButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.arrowLeft.image, for: .normal)
        $0.tintColor = DSKitAsset.Colors.white.color
    }

    private let titleLabel = UILabel().then {
        $0.text = I18N.MyPage.SoptampSection.clapList
        $0.font = .SoptampFont.h2
        $0.textColor = DSKitAsset.Colors.white.color
    }

    private let containerView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray900.color
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }

    private lazy var clapListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = true
        $0.delegate = self
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
        view.backgroundColor = DSKitAsset.Colors.black.color.withAlphaComponent(0.8)
        navigationController?.isNavigationBarHidden = true
    }

    private func setLayout() {
        view.addSubview(containerView)
        containerView.addSubviews(backButton, titleLabel, clapListCollectionView)

        containerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(164)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
        }

        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(12)
        }

        clapListCollectionView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Bindings

extension ClapListVC {

    private func bindViews() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        onNaviBackTap?()
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
        self.applySnapshot(model: model)
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
        onCellTap?(model.nickname)
    }
}
