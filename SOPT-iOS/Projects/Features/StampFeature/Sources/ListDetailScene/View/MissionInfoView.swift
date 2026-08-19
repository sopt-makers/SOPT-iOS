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
import MDS

final class MissionInfoView: UIView {
    private lazy var clapStackView = UIStackView()
    private lazy var viewStackView = UIStackView()
    private let clapImageView = UIImageView().then {
        $0.image = MDSIcon.clapRoundOutlined.image.withTintColor(SemanticColor.Fg.Neutral.subtle)
    }
    private let viewImageView = UIImageView().then {
        $0.image = MDSIcon.eyeOutlined.image.withTintColor(SemanticColor.Fg.Neutral.subtle)
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
        self.makeText(self.dateLabel)
        self.makeText(self.clapCountLabel)
        self.makeText(self.viewCountLabel)
    }

    func setClapText(clapCount: Int) {
        self.clapCountLabel.text = String(clapCount)
        self.makeText(self.clapCountLabel)
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
            $0.height.equalTo(18)
        }
        
        self.dateLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        
        viewStackView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        clapStackView.snp.makeConstraints {
            $0.trailing.equalTo(viewStackView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }

        clapImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }

        viewImageView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
    }
}

extension MissionInfoView {
    private func makeStackView(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = 2
    }
    
    private func makeText(_ label: UILabel) {
        label.setTypography(Typography.label4,
                            textColor: SemanticColor.Fg.Neutral.subtle)
    }
}
