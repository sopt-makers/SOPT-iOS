//
//  UserHistoryCVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class UserHistoryCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let historyOpacityScale: [Float] = [1.0, 0.7, 0.5, 0.3, 0.2]
    private let numberOfHistoryToShow: Int = 5
    
    // MARK: - UI Components
    
    private let userTypeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = DSKitAsset.Colors.black40.color
        label.textColor = DSKitAsset.Colors.white100.color
        label.font = UIFont.Main.caption1
        label.text = I18N.Main.visitor
        label.layer.cornerRadius = 12
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    private var historyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension UserHistoryCVC {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(userTypeLabel, historyStackView)
        
        userTypeLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(82)
        }
        
        historyStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(userTypeLabel.snp.trailing).offset(8)
        }
    }
    
    private func resizeHistoryStackSubviews() {
        self.historyStackView.subviews.forEach { view in
            view.snp.makeConstraints { make in
                make.width.equalTo(view.snp.height)
            }
        }
    }
}

// MARK: - Methods

extension UserHistoryCVC {
    
    func initCell(userType: UserType, recentHistory: Int?, allHistory: [Int]?) {
        // 현재 활동 기수 여부 뷰 설정
        self.userTypeLabel.text = userType.makeDescription(recentHistory: recentHistory ?? 0)
        if userType == .active {
            self.userTypeLabel.backgroundColor = DSKitAsset.Colors.purple100.color
        }
        
        guard userType != .visitor else { return }
        
        historyStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        // 활동 기수들 내역 나열한다.
        guard let allHistory = allHistory else { return }
        for (index, history) in allHistory.enumerated() {
            if index >= numberOfHistoryToShow { break }
            let historyView = self.makeHistoryView(index: index, history: String(history))
            self.historyStackView.addArrangedSubview(historyView)
        }
        
        // 5개 이상의 기수를 활동한 경우 +n 으로 나타낸다.
        let remaining = allHistory.count - numberOfHistoryToShow
        if remaining > 0 {
            let remainingView = makeHistoryView(index: 0, history: "+\(remaining)")
            remainingView.backgroundColor = DSKitAsset.Colors.black80.color
            self.historyStackView.addArrangedSubview(remainingView)
        }
        
        // 스택뷰의 서브뷰들의 높이와 넓이를 같게하여 원 모양으로 만든다.
        resizeHistoryStackSubviews()
    }
    
    private func makeHistoryView(index: Int, history: String) -> UILabel {
        let label = UILabel()
        label.backgroundColor = DSKitAsset.Colors.black40.color
        label.layer.opacity = historyOpacityScale[index]
        label.font = UIFont.Main.caption1
        label.textColor = DSKitAsset.Colors.white100.color
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.text = history
        
        return label
    }
}
