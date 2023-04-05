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
        let text = (userType == .visitor) ? "\(name) 님, \nSopt의 열정이 되어주세요!" : "\(name) 님은 \nSOPT와 D+\(days)일째"

        let attributedText = NSMutableAttributedString(string: text,
                                                      attributes: [
                                                         .foregroundColor: DSKitAsset.Colors.white100.color,
                                                         .font: UIFont.Main.display2
                                                      ])
        attributedText.addAttribute(.font,
                                     value: UIFont.Main.display1,
                                     range: (text as NSString).range(of:"\(name)"))

        self.userInfoLabel.attributedText = attributedText
    }
}
