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
        label.text = I18N.Main.welcome
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
    
    func initCell(userType: UserType, name: String?, months: String?) {
        // 회원 타입에 따른 분기 처리 (추후 플그 기수 입력이 필수가 되면 변경 예정)
        if let name = name, let months = months {
            let text = (userType == .visitor) ? I18N.Main.encourage : I18N.Main.userHistory(name: name, months: months)

            let attributedText = NSMutableAttributedString(string: text,
                                                          attributes: [
                                                             .foregroundColor: DSKitAsset.Colors.white100.color,
                                                             .font: UIFont.Main.display2
                                                          ])
            attributedText.addAttribute(.font,
                                         value: UIFont.Main.display1,
                                         range: (text as NSString).range(of:"\(name)"))
            
            attributedText.addAttribute(.font,
                                         value: UIFont.Main.display1,
                                        range: (text as NSString).range(of:I18N.Main.hello))

            self.userInfoLabel.attributedText = attributedText
        } else {
            if userType == .visitor {
                let text = I18N.Main.encourage
                let attributedText = NSMutableAttributedString(string: text,
                                                              attributes: [
                                                                 .foregroundColor: DSKitAsset.Colors.white100.color,
                                                                 .font: UIFont.Main.display2
                                                              ])
                attributedText.addAttribute(.font,
                                             value: UIFont.Main.display1,
                                            range: (text as NSString).range(of: I18N.Main.hello))
                self.userInfoLabel.attributedText = attributedText
            } else if userType == .inactive {
                let text = I18N.Main.welcome
                let attributedText = NSMutableAttributedString(string: text,
                                                              attributes: [
                                                                 .foregroundColor: DSKitAsset.Colors.white100.color,
                                                                 .font: UIFont.Main.display2
                                                              ])
                attributedText.addAttribute(.font,
                                             value: UIFont.Main.display1,
                                            range: (text as NSString).range(of: I18N.Main.hello))
                self.userInfoLabel.attributedText = attributedText
            }
        }
    }
}
