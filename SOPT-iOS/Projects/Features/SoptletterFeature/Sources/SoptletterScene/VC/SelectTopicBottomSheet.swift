//
//  SelectTopicBottomSheet.swift
//  SoptletterFeature
//
//  Created by 이나연 on 10/14/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit
import MDS
import SoptletterFeatureInterface

final class SelectTopicBottomSheet: UIViewController {
    
    // MARK: - Properties

    private var topics: [SoptletterTopicModel] = [
        .init(topicId: 1, title: "제목", isDefault: true, createdAt: ""),
        .init(topicId: 2, title: "제목", isDefault: true, createdAt: ""),
        .init(topicId: 3, title: "제목", isDefault: true, createdAt: ""),
        .init(topicId: 4, title: "제목", isDefault: true, createdAt: ""),
        .init(topicId: 5, title: "제목", isDefault: true, createdAt: ""),
        .init(topicId: 6, title: "제목", isDefault: true, createdAt: ""),
        .init(topicId: 7, title: "제목", isDefault: true, createdAt: "")
    ]
    
    private var selectedIndex: Int?
    
    private var didScrollToSelectedRow = false
    
    // MARK: - UI Components
    
    private let sheetContainerView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let naviContainerView = UIView()
    
    private lazy var backButton = UIButton(type: .custom).then {
        $0.setImage(MDSIcon.chevronLeftOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
        $0.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
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
        $0.addTarget(self, action: #selector(confirmButtonTap), for: .touchUpInside)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc private func confirmButtonTap() {
        // TODO: 서버 연결하면서 구현
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
            description: "디스크립션션션션션션",
            isHot: true,
            isNew: false,
            isSelected: indexPath.row == selectedIndex
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        selectedIndex = indexPath.row
        let targets = [previousIndex, indexPath.row]
            .compactMap { $0 }
            .map { IndexPath(row: $0, section: 0) }
        tableView.reloadRows(at: targets, with: .none)
        
        confirmButton.isEnabled = true
    }
}
