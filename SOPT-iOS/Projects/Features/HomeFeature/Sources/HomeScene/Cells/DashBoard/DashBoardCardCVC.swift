//
//  DashBoardCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class DashBoardCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
        
    private var descriptionLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 18)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    private let userHistoryView = UserHistoryView()
    
    private let rightArrowWithCircleImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnRightArrowWithCircle.image
    }
    
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

extension DashBoardCardCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        self.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        self.addSubviews(
            descriptionLabel,
            userHistoryView,
            rightArrowWithCircleImageView
        )

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(16)
        }
        
        userHistoryView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(250)
            make.height.equalTo(23)
        }
        
        rightArrowWithCircleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
    }
}

// MARK: - Methods

extension DashBoardCardCVC {
    func configureCell(userType: UserType, description: String?) {
        guard let description = description else { return }

        switch userType {
        case .visitor:
            self.descriptionLabel.font = DSKitFontFamily.Suit.medium.font(size: 18)
            self.descriptionLabel.text = I18N.Home.DashBoard.UserHistory.encourage
            self.descriptionLabel.setLineSpacing(lineSpacing: 5)
            self.rightArrowWithCircleImageView.isHidden = true
        case .active, .inactive:
            self.descriptionLabel.text = description
            setDescriptionLabel(description)
            self.rightArrowWithCircleImageView.isHidden = false
        }
        
        userHistoryView.setData(userType: userType, recentHistory: 35, allHistory: [35, 34, 33, 32, 31, 30, 29])
    }
    
    /// 볼드 태그로 감싸진 텍스트만 추출해서, 볼드 처리
    func setDescriptionLabel(_ description: String) {
        if description.isEmpty { return }
        
        do {
            let pattern = "<b>(.*?)</b>"
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(description.startIndex..., in: description)
            let modifiedDescription = regex.stringByReplacingMatches(in: description, options: [], range: range, withTemplate: "$1")    // 태그가 삭제된 값
            
            self.descriptionLabel.text = modifiedDescription
            
            // 태그로 감싸진 값 탐색
            let matches = regex.matches(in: description, options: [], range: NSRange(description.startIndex..., in: description))

            for match in matches {
                if let range = Range(match.range(at: 1), in: description) {
                    let matchText = description[range]
                    self.descriptionLabel.partFontChange(targetString: String(matchText),
                                                         font: DSKitFontFamily.Suit.bold.font(size: 18),
                                                         lineSpacing: 5)
                }
            }
        } catch {
            print("정규식 오류: \(error)")
        }
    }

}
