//
//  PokeMessageTemplateBottomSheet.swift
//  PokeFeature
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import MDS

import BaseFeatureDependency

public final class PokeMessageTemplateBottomSheet: UIViewController, PokeMessageTemplatesViewControllable {
    
    public var minimumContentHeight: CGFloat {
        return PokeMessageTemplateBottomSheet.minimumContentHeight
    }
    
    private enum Metric {
        static let contentTop = 24.f
        static let contentLeadingTrailng = 20.f
        
        static let scrollViewTop = 12.f
        
        static let anonymousStackViewSpacing = 8.f
        static let anonymousCheckboxLength = 22.f
        
        static let contentStackViewSpacing = 4.f
    }
    
    public static let minimumContentHeight = 366.f
    
    // MARK: - Views
    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
        $0.isScrollEnabled = true
    }
    
    private let scrollContainerStackView = UIStackView().then {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = Metric.contentStackViewSpacing
    }
    
    private let messegeTemplateTitleLabel = UILabel().then {
        $0.text = I18N.Poke.MessaeBottomSheet.title
        $0.setTypography(Typography.title3, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private let anonymousCheckbox = MDSCheckbox(size: .large, title: I18N.Poke.MessaeBottomSheet.anonymous).then {
        $0.isUserInteractionEnabled = false
    }
    
    private let anonymousCheckboxContainer = UIView()
    
    // MARK: - Variables
    private let viewModel: PokeMessageTemplateViewModel
    
    // MARK: Combine
    private let viewDidLoaded = PassthroughSubject<Void, Never>()
    private let messageModelSubject = PassthroughSubject<(PokeMessageModel, isAnonymous: Bool), Error>()
    private var isAnonymousAvailable = false
    
    private var cancelBag = CancelBag()
    
    public init(viewModel: PokeMessageTemplateViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = SemanticColor.Bg.Neutral.ghost
        
        self.initializeViews()
        self.setupConstraints()
        self.bindViewModels()
        self.initializeButtonActions()
        
        self.viewDidLoaded.send(())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokeMessageTemplateBottomSheet {
    private func initializeViews() {
        self.view.addSubviews(
            self.messegeTemplateTitleLabel,
            self.anonymousCheckboxContainer,
            self.scrollView
        )
        
        self.anonymousCheckboxContainer.addSubview(self.anonymousCheckbox)
        
        self.scrollView.addSubview(self.scrollContainerStackView)
    }
    
    private func setupConstraints() {
        self.messegeTemplateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(Metric.contentTop)
            $0.leading.trailing.equalToSuperview().inset(Metric.contentLeadingTrailng)
        }
        
        self.anonymousCheckbox.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.anonymousCheckboxContainer.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Metric.contentLeadingTrailng)
            $0.centerY.equalTo(self.messegeTemplateTitleLabel.snp.centerY)
        }
        
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.messegeTemplateTitleLabel.snp.bottom).offset(Metric.scrollViewTop)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.scrollContainerStackView.snp.makeConstraints {
            $0.top.leading.trailing.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}

extension PokeMessageTemplateBottomSheet {
    func configure(with messagesModel: PokeMessagesModel) {
        self.messegeTemplateTitleLabel.text = messagesModel.header
        self.messegeTemplateTitleLabel.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold)
        messagesModel.messages.forEach {
            let bottomsheetContentView = PokeBottomSheetMessageView(frame: self.view.frame)
            bottomsheetContentView.configure(with: $0)
            bottomsheetContentView
                .signalForClick()
                .sink(receiveValue: { [weak self] value in
                    let isAnonymous = self?.anonymousCheckbox.isSelected ?? false
                    self?.messageModelSubject.send((value, isAnonymous: isAnonymous))
                    self?.dismiss(animated: true)
                }).store(in: self.cancelBag)
            
            self.scrollContainerStackView.addArrangedSubview(bottomsheetContentView)
        }
    }
    
    public func signalForClick() -> Driver<(PokeMessageModel, isAnonymous: Bool)> {
        return self.messageModelSubject.asDriver()
    }
}


// MARK: - ViewModel Methods
extension PokeMessageTemplateBottomSheet {
    private func bindViewModels() {
        let input = PokeMessageTemplateViewModel.Input(viewDidLoaded: self.viewDidLoaded.asDriver())
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output
            .messageTemplates
            .asDriver()
            .sink(receiveValue: { [weak self] values in
                self?.configure(with: values)
            }).store(in: self.cancelBag)
        
        // messageTemplateConfig 상태에 따라서 체크박스 활성화 여부 설정
        output
            .messageTemplateConfig
            .asDriver()
            .sink { [weak self] messageTemplateConfig in
                self?.isAnonymousAvailable = messageTemplateConfig.isAnonymousSelectionAvailable
                self?.anonymousCheckbox.isEnabled = messageTemplateConfig.isAnonymousSelectionAvailable
                self?.anonymousCheckbox.isSelected = messageTemplateConfig.isAnonymousSelectionAvailable
            }
            .store(in: self.cancelBag)
    }
    
    private func initializeButtonActions() {
        self.anonymousCheckboxContainer
            .gesture()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                guard isAnonymousAvailable else {
                    ToastUtils.showMDSToast(
                        type: .alert,
                        text: I18N.Poke.MessaeBottomSheet.onlyReal
                    )
                    return
                }
                
                let isSelected = anonymousCheckbox.isSelected
            
                anonymousCheckbox.isSelected.toggle()
                
                if isSelected {
                    ToastUtils.showMDSToast(
                        type: .alert,
                        text: I18N.Poke.MessaeBottomSheet.revealNotice
                    )
                }
            }).store(in: self.cancelBag)
    }
}
