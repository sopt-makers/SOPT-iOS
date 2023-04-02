//
//  UserHistoryHeaderView.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class UserHistoryHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.white100.color
        label.font = UIFont.Main.display2
        label.numberOfLines = 2
        label.textAlignment = .left
        label.text = "OOO님은\nSOPT와 D+1234일째"
        return label
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

// MARK: - UI & Layout

extension UserHistoryHeaderView {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(userInfoLabel)
        userInfoLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func initCell(userType: UserType, name: String, days: String) {
        let text = NSMutableAttributedString(string: name,
                                             attributes: [
                                                .foregroundColor: DSKitAsset.Colors.white100.color,
                                                .font: UIFont.Main.display1
                                             ])
        
        if userType == .visitor {
            text.append(NSAttributedString(string: " 님, \nSopt의 열정이 되어주세요!",
                                           attributes: [
                                            .foregroundColor: DSKitAsset.Colors.white100.color,
                                                .font: UIFont.Main.display1]
                                          ))
        } else {
            text.append(NSAttributedString(string: " 님은 \nSOPT와 D+\(days)일째",
                                           attributes: [
                                            .foregroundColor: DSKitAsset.Colors.white100.color,
                                                .font: UIFont.Main.display1]
                                          ))
        }

        self.userInfoLabel.attributedText = text
    }
}
