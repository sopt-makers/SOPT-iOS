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

final class ClapListViewController: UIViewController {

    // MARK: - Properties

    private var cancelBag = Set<AnyCancellable>()
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
    }

    private let emptyView = UILabel().then {
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
        self.applyInitialSnapshot()
    }

    // TODO: - init(viewModel:) 주입 예정
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension ClapListViewController {

    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.gray950.color
        navigationController?.isNavigationBarHidden = true
    }

    private func setLayout() {
        view.addSubviews(naviBar, clapListCollectionView, emptyView)

        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        clapListCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - CollectionView

extension ClapListViewController {

    // TODO: - bindView(), bindViewModel() 추후 구현
    private func bindViews() {}
    private func bindViewModel() {}

}

extension ClapListViewController {
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

    private func applyInitialSnapshot() {
        let mock = [
            ClapListModel(name: "서버황혜린", subtitle: "최대글자수최대글자수최대글자수", clapCount: 50),
            ClapListModel(name: "서버황혜린", subtitle: "최대글자수최대글자수최대글자수", clapCount: 50),
            ClapListModel(name: "서버황혜린", subtitle: "최대글자수최대글자수최대글자수", clapCount: 50),
            ClapListModel(name: "서버황혜린", subtitle: "최대글자수최대글자수최대글자수", clapCount: 50)
        ]

        var snapshot = NSDiffableDataSourceSnapshot<ClapListSection, ClapListModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mock)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Section Enum

enum ClapListSection: CaseIterable {
    case main
}

// MARK: - UICollectionViewDelegate

extension ClapListViewController: UICollectionViewDelegate {


}
