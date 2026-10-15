//
//  SelectTopicBottomSheet.swift
//  SoptletterFeature
//
//  Created by 이나연 on 10/14/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine

import Core
import Domain
import DSKit
import MDS
import SoptletterFeatureInterface

final class SelectTopicBottomSheet: UIViewController {
    
    // MARK: - Properties

    private let viewModel: SelectTopicBottomSheetViewModel
    private let cancelBag = CancelBag()
    private var topics: [SoptletterTopicModel] = []
    private var selectedIndex: Int?
    
    private lazy var naviBackTap: Driver<Void> = backButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()

    private let cellTapSubject = PassthroughSubject<SoptletterTopicModel, Never>()
    
    private lazy var confirmButtonTap: Driver<Void> = confirmButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    // MARK: - UI Components
    
    private let sheetContainerView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let naviContainerView = UIView()
    
    private lazy var backButton = UIButton(type: .custom).then {
        $0.setImage(MDSIcon.chevronLeftOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = I18N.Soptletter.selectTopicText
        $0.setTypography(Typography.heading3, textColor: DSKitAsset.Colors.gray10.color)
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.rowHeight = 66
        SelectTopicDropDownCell.register(target: $0)
    }
    
    private lazy var confirmButton = MDSActionButton(variant: .primary, size: .large, title: "선택 완료").then {
        $0.isEnabled = false
    }
    
    init(viewModel : SelectTopicBottomSheetViewModel) {
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
        bindViewModels()
    }
    
    func bindViewModels() {
        let input = SelectTopicBottomSheetViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            naviBackTap: naviBackTap,
            cellTap: cellTapSubject.asDriver(),
            confirmButtonTap: confirmButtonTap.asDriver()
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.topicsSubject
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, result in
                owner.topics = result.topics
                owner.tableView.reloadData()
            }.store(in: cancelBag)
        
        output.initialSelectedIndex
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, index in
                owner.selectedIndex = index
                owner.confirmButton.isEnabled = true
                owner.tableView.reloadData()
                owner.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
            }.store(in: cancelBag)
    }
}

// MARK: - Layout

extension SelectTopicBottomSheet {
    private func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(sheetContainerView)
        sheetContainerView.addSubviews(naviContainerView, tableView, confirmButton)
        naviContainerView.addSubviews(backButton, titleLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setLayout() {
        sheetContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s28)
            make.height.equalTo(478)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(BaseSpacing.Base.s16)
        }
        
        naviContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(BaseSpacing.Base.s12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(38)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(11)
            make.leading.equalToSuperview().inset(BaseSpacing.Base.s8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(BaseSpacing.Base.s8)
            make.leading.equalTo(backButton.snp.trailing).offset(8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviContainerView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s8)
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(BaseSpacing.Base.s12)
            make.horizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s16)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SelectTopicBottomSheet: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectTopicDropDownCell.className,
            for: indexPath
        ) as? SelectTopicDropDownCell else { return UITableViewCell() }
        
        cell.configure(
            title: topics[indexPath.row].title,
            description: topics[indexPath.row].subtitle ?? "",
            isHot: topics[indexPath.row].isHot,
            isNew: topics[indexPath.row].isNew,
            isSelected: indexPath.row == selectedIndex
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        selectedIndex = indexPath.row
        cellTapSubject.send(topics[selectedIndex ?? 0])
        let targets = [previousIndex, indexPath.row]
            .compactMap { $0 }
            .map { IndexPath(row: $0, section: 0) }
        tableView.reloadRows(at: targets, with: .none)
        
        confirmButton.isEnabled = true
    }
}
