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
import DSKit
import SoptletterFeatureInterface

final class SelectTopicVC: SelectTopicPresentable {
    
    var onNaviBackTap: (() -> Void)?
    var onCellTap: ((String) -> Void)?
    
    // MARK: - Properties
    // 임시
    private var topics: [String] = [
        "12기 회고",
        "13기 회고",
        "38기 회고"
    ]
    
    private let backButton = UIButton(type: .custom).then {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
}

extension SelectTopicVC {
    func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setLayout() {
        view.addSubviews(backButton, navTitleLabel, tableView)
        
        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(32)
        }
        
        navTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(12)
            make.centerY.equalTo(backButton)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(110)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SelectTopicVC: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SoptletterTopicCell.identifier,
            for: indexPath
        ) as? SoptletterTopicCell else { return UITableViewCell() }
        
        cell.configure(title: topics[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = topics[indexPath.row]
        onCellTap?(title)
    }
}
