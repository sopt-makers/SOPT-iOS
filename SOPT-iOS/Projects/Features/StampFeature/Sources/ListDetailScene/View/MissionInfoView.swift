//
//  MissionInfoView.swift
//  StampFeature
//
//  Created by 최주리 on 10/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine
import UIKit

import Core
import DSKit

final class MissionInfoView: UIView {
    private enum Metric {
        static let height = 18
        static let contentLeadingTrailing = -8
    }
    
    private lazy var clapStackView = UIStackView()
    private lazy var viewStackView = UIStackView()
    private let clapImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icClapMini.image
    }
    private let viewImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icCommunicationEye.image
    }

    private let dateLabel = UILabel()
    private let clapCountLabel = UILabel()
    private let viewCountLabel = UILabel()
    
    // MARK: - Private Variables
    private var cancelBag = CancelBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setUI()
        self.initializeViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public functions
extension MissionInfoView {
    func setFullText(date: String, clapCount: Int, viewCount: Int) {
        self.dateLabel.text = date
        self.clapCountLabel.text = String(clapCount)
        self.viewCountLabel.text = String(viewCount)
    }
    
    func setClapText(clapCount: Int) {
        self.clapCountLabel.text = String(clapCount)
    }
}

// MARK: - UI
extension MissionInfoView {
    private func setUI() {
        makeStackView(self.clapStackView)
        makeStackView(self.viewStackView)
        
        makeText(self.dateLabel)
        makeText(self.clapCountLabel)
        makeText(self.viewCountLabel)
    }
    
    private func initializeViews() {
        self.addSubviews(self.dateLabel, self.clapStackView, self.viewStackView)
        
        self.clapStackView.addArrangedSubviews(self.clapImageView, self.clapCountLabel)
        self.viewStackView.addArrangedSubviews(self.viewImageView, self.viewCountLabel)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(Metric.height)
        }
        
        self.dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        viewStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        clapStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(viewStackView.snp.leading).offset(Metric.contentLeadingTrailing)
            $0.centerY.equalToSuperview()
        }
    }
    
}

extension MissionInfoView {
    private func makeStackView(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = 1
    }
    
    private func makeText(_ label: UILabel) {
        label.textColor = DSKitAsset.Colors.gray300.color
        label.font = DSKitFontFamily.Suit.medium.font(size: 12)
    }
}
