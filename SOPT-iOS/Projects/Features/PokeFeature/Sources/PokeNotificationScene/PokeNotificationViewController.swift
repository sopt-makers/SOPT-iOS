//
//  PokeNotificationViewController.swift
//  PokeFeature
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import BaseFeatureDependency
import Core
import Domain
import DSKit

import SnapKit

public final class PokeNotificationViewController: UIViewController, PokeNotificationViewControllable {
    private enum Metric {
        static let navigationbarHeight = 44.f
        
        static let tableViewTop = 10.f
        static let tableViewHeaderHeight = 37.f
        static let tableViewHeaderLeadingTrailng = 20.f
        static let tableViewHeaderBottom = 9.f
    }
    
    // MARK: - Views
    private lazy var navigationBar = OPNavigationBar(
        self,
        type: .oneLeftButton,
        backgroundColor: DSKitAsset.Colors.gray950.color
    )
        .addMiddleLabel(title: "찌르기 알림", font: UIFont.MDS.body2)
        .setLeftButtonImage(DSKitAsset.Assets.chevronLeft.image.withTintColor(DSKitAsset.Colors.gray30.color))
    
    private let headerView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8.f
    }
    private let titleLabel = UILabel().then {
        $0.text = "누가 나를 찔렀어요"
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
        $0.textColor = DSKitAsset.Colors.gray30.color
    }
    private let descriptionLabel = UILabel().then {
        $0.text = "나도 찔러서 답장을 해보세요"
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray200.color
    }
    
    // MARK: TableViews
    private lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(
            PokeNotificationContentCell.self,
            forCellReuseIdentifier: PokeNotificationContentCell.className
        )
        $0.backgroundColor = DSKitAsset.Colors.gray950.color
        $0.estimatedRowHeight = 88.f
    }
    
    // MARK: - Variables
    private let viewModel: PokeNotificationViewModel
    private let cancelBag = CancelBag()
    private var userModels: [PokeUserModel] = []
    
    // MARK: Combine
    private let viewDidLoaded = PassthroughSubject<Void, Never>()
    private let pokedActionSubject = PassthroughSubject<PokeUserModel, Never>()
    private let reachToBottomSubject = PassthroughSubject<Void, Never>()
    
    init(viewModel: PokeNotificationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokeNotificationViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DSKitAsset.Colors.gray950.color
        self.navigationController?.navigationBar.isHidden = true
        
        self.initializeViews()
        self.setupConstraints()
        
        self.bindViews()
        self.bindViewModels()
        
        self.viewDidLoaded.send(())
    }
}

extension PokeNotificationViewController {
    private func initializeViews() {
        self.view.addSubviews(self.navigationBar, self.tableView)
        
        self.tableView.tableHeaderView = self.headerView
        self.headerView.frame = .init(
            x: 0,
            y: 0,
            width: self.view.frame.width,
            height: Metric.tableViewHeaderHeight
        )
        self.headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.tableViewHeaderLeadingTrailng)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Metric.tableViewHeaderBottom)
            $0.height.equalTo(Metric.tableViewHeaderHeight)
        }
        self.headerView.addArrangedSubviews(self.titleLabel, self.descriptionLabel)
    }
    
    private func setupConstraints() {
        self.navigationBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.navigationbarHeight)
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.navigationBar.snp.bottom).offset(Metric.tableViewTop)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindViews() {
        self.tableView
            .publisher(for: \.contentOffset)
            .map { [weak self] offset in
                guard 
                    offset.y > 0,
                    let tableView = self?.tableView,
                    tableView.contentOffset.y >= tableView.contentSize.height - tableView.frame.size.height
                else { return false }
                
                return true
            }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] reachedToBottom in
                guard reachedToBottom else { return }
                
                self?.reachToBottomSubject.send(())
            }).store(in: self.cancelBag)
    }
    
    private func bindViewModels() {
        let input = PokeNotificationViewModel.Input(
            viewDidLoaded: self.viewDidLoaded.asDriver(),
            reachToBottom: self.reachToBottomSubject.asDriver(),
            pokedAction: self.pokedActionSubject.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output
            .pokeToMeHistoryList
            .sink(receiveValue: { [weak self] userModels in
                self?.userModels.append(contentsOf: userModels)
                self?.tableView.reloadData()
            }).store(in: self.cancelBag)
        
        output
            .pokedResult
            .asDriver()
            .sink(receiveValue: { [weak self] pokedResult in
                guard 
                    let pokedUserIndex = self?.userModels.firstIndex(where: { $0.userId == pokedResult.userId })
                else { return }
                
                self?.userModels[pokedUserIndex] = pokedResult
                self?.tableView.reloadData()
            }).store(in: self.cancelBag)
    }
}

extension PokeNotificationViewController: UITableViewDelegate { }
extension PokeNotificationViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PokeNotificationContentCell.className,
                for: indexPath
            ) as? PokeNotificationContentCell,
            let model = self.userModels[safe: indexPath.item]
        else { return UITableViewCell() }
        
        cell.configure(with: model)

        cell.signalForClick()
            .sink(receiveValue: { [weak self] userModel in
                self?.pokedActionSubject.send(userModel)
            }).store(in: cell.cancelBag)
        
        return cell
    }
}
