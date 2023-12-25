//
//  MDSToast.swift
//  DSKit
//
//  Created by sejin on 12/25/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core

public class MDSToast: UIView {
    
    // MARK: - Properties
    
    private let type: ToastType
    private let text: String
    private var linkButtonAction: (() -> Void)?
    private let cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let toastIconImageView = UIImageView()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.MDS.label3
        label.textColor = DSKitAsset.Colors.gray900.color
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let linkButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        let attributes = AttributeContainer([.font: UIFont.MDS.label3,
                                             .foregroundColor: DSKitAsset.Colors.success])
        
        var title = AttributedString.init("보러가기", attributes: attributes)
        
        config.attributedTitle = title
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - initialization
    
    public init(type: ToastType, text: String, linkButtonAction: (() -> Void)? = nil) {
        self.type = type
        self.text = text
        self.linkButtonAction = linkButtonAction
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
        self.setLinkButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.toastIconImageView.image = self.type.icon
        self.contentLabel.text = self.text
        self.backgroundColor = DSKitAsset.Colors.gray10.color
        self.clipsToBounds = true
        self.layer.cornerRadius = 18
        self.fillStackView()
    }
    
    private func fillStackView() {
        switch type {
        case .default:
            containerStackView.addArrangedSubviews(contentLabel)
        case .actionButton:
            containerStackView.addArrangedSubviews(toastIconImageView, contentLabel, linkButton)
        default:
            containerStackView.addArrangedSubviews(toastIconImageView, contentLabel)
        }
    }
    
    private func setLayout() {
        addSubview(containerStackView)
        
        toastIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        linkButton.snp.contentHuggingHorizontalPriority = 999
        
        containerStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(14)
        }
    }
    
    private func setLinkButtonAction() {
        self.linkButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.linkButtonAction?()
            }.store(in: cancelBag)
    }
}

public extension MDSToast {
    enum ToastType {
        case `default`
        case success
        case alert
        case error
        case actionButton
        
        var icon: UIImage {
            switch self {
            case .alert:
                return DSKitAsset.Assets.toastAlert.image
            default: // TODO: MDS 피그마 export 권한 생기면 추가 예정
                return DSKitAsset.Assets.toastAlert.image
            }
        }
    }
}
