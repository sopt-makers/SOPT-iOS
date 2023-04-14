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
        label.text = "OOO님은\nSOPT와 N개월째"
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
            let text = (userType == .visitor) ? "안녕하세요, \nSOPT의 열정이 되어주세요!" : "\(name) 님은 \nSOPT와 \(months)개월째"

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
                                         range: (text as NSString).range(of:"안녕하세요"))

            self.userInfoLabel.attributedText = attributedText
        } else {
            if userType == .visitor {
                let text = "안녕하세요, \nSOPT의 열정이 되어주세요!"
                let attributedText = NSMutableAttributedString(string: text,
                                                              attributes: [
                                                                 .foregroundColor: DSKitAsset.Colors.white100.color,
                                                                 .font: UIFont.Main.display2
                                                              ])
                attributedText.addAttribute(.font,
                                             value: UIFont.Main.display1,
                                             range: (text as NSString).range(of:"안녕하세요"))
                self.userInfoLabel.attributedText = attributedText
            } else if userType == .inactive {
                let text = "안녕하세요, \nSOPT에 오신 것을 환영합니다!"
                let attributedText = NSMutableAttributedString(string: text,
                                                              attributes: [
                                                                 .foregroundColor: DSKitAsset.Colors.white100.color,
                                                                 .font: UIFont.Main.display2
                                                              ])
                attributedText.addAttribute(.font,
                                             value: UIFont.Main.display1,
                                             range: (text as NSString).range(of:"안녕하세요"))
                self.userInfoLabel.attributedText = attributedText
            }
        }
    }
}
