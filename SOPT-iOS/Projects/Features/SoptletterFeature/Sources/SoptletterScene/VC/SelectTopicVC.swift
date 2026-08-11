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
import MDS
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
        $0.setImage(MDSIcon.chevronLeftOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
    }
    
    private let navTitleLabel = UILabel().then {
        $0.text = I18N.Soptletter.topicTitle
        $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 46
        $0.contentInset = UIEdgeInsets(top: BaseSpacing.Base.s12, left: 0, bottom: BaseSpacing.Base.s20, right: 0)
        SoptletterTopicCell.register(target: $0)
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
        view.backgroundColor = SemanticColor.Bg.Layer.basement
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubviews(backButton, navTitleLabel, tableView)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).inset(BaseSpacing.Base.s12)
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s20)
            make.size.equalTo(BaseSpacing.Base.s24)
        }

        navTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(BaseSpacing.Base.s12)
            make.centerY.equalTo(backButton)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(BaseSpacing.Base.s16)
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
            .receive(on: DispatchQueue.main)
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
            withIdentifier: SoptletterTopicCell.className,
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
