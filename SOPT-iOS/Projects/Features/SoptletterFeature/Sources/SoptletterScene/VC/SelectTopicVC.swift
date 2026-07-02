//
//  SelectTopicVC.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/21/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine

import Core
import Domain
import DSKit
import SoptletterFeatureInterface

final class SelectTopicVC: UIViewController {
    
    private let viewModel: SelectTopicViewModel
    private let cancelBag = CancelBag()
    
    private lazy var naviBackTap: Driver<Void> = backButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    private let cellTapSubject = PassthroughSubject<SoptletterTopicModel, Never>()
    
    private var topics: [SoptletterTopicModel] = []
    
    // MARK: - Properties
    
    private lazy var backButton = UIButton(type: .custom).then {
        $0.setImage(DSKitAsset.Assets.opArrowWhite.image, for: .normal)
    }
    
    private let navTitleLabel = UILabel().then {
        $0.text = I18N.Soptletter.topicTitle
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.font = DSKitFontFamily.Pretendard.bold.font(size: 18)
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 52
        $0.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 20, right: 0)
        $0.register(SoptletterTopicCell.self, forCellReuseIdentifier: SoptletterTopicCell.identifier)
    }
    
    init(viewModel: SelectTopicViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        bindViewModel()
    }
    
}

extension SelectTopicVC {
    func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubviews(backButton, navTitleLabel, tableView)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).inset(12)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(32)
        }
        
        navTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(12)
            make.centerY.equalTo(backButton)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(22)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = SelectTopicViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            naviBackTap: naviBackTap,
            cellTap: cellTapSubject.asDriver()
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.topicsSubject
            .withUnretained(self)
            .sink { owner, result in
                owner.topics = result.topics
                owner.tableView.reloadData()
            }.store(in: cancelBag)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SelectTopicVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SoptletterTopicCell.identifier,
            for: indexPath
        ) as? SoptletterTopicCell else { return UITableViewCell() }
        
        cell.configure(title: topics[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cellTapSubject.send(topics[indexPath.row])
    }
}
