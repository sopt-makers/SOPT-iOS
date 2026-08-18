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
import MDS

import Combine
import SnapKit
import Then

final class ClapListVC: UIViewController, ClapListViewControllable {

    // MARK: - Properties

    private var cancelBag = CancelBag()
    private var viewModel: ClapListViewModel
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    lazy var dataSource: UICollectionViewDiffableDataSource<ClapListSection, ClapperModel>! = nil

    // MARK: - ClapListCoordinatable

    public var onNaviBackTap: (() -> Void)?
    public var onCellTap: ((String?, String?) -> Void)?

    // MARK: - UI Components

    private let backButton = UIButton().then {
        $0.setImage(MDSIcon.chevronLeftOutlined.image, for: .normal)
        $0.tintColor = SemanticColor.Fg.Neutral.bold
    }

    private let titleLabel = UILabel().then {
        $0.text = I18N.MyPage.SoptampSection.clapList
        $0.setTypography(Typography.title3, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private let containerView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.ghost
        $0.layer.cornerRadius = BaseRadius.Base.r20
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
        self.viewDidLoadSubject.send(())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        if !containerView.frame.contains(touch.location(in: view)) {
            onNaviBackTap?()
        }
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
        view.backgroundColor = SemanticColor.Bg.Dim.default
        navigationController?.isNavigationBarHidden = true
    }

    private func setLayout() {
        view.addSubview(containerView)
        containerView.addSubviews(backButton, titleLabel, clapListCollectionView)

        containerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(164)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }

        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
        }

        clapListCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
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
            viewDidLoad: viewDidLoadSubject.asDriver()
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

    func setCollectionView(model: [ClapperModel]) {
        self.applySnapshot(model: model)
    }

    private func applySnapshot(model: [ClapperModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<ClapListSection, ClapperModel>()
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
        onCellTap?(model.nickname, model.profileMessage)
    }
}
