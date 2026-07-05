//
//  SoptletterMainVC.swift
//  SoptletterFeature
//
//  Created by dev on 6/29/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit

import BaseFeatureDependency
import Core
import DSKit
import Domain

public final class SoptletterMainVC: UIViewController, SoptletterViewControllable {
    
    // MARK: - UI Properties
    
    private let navigationView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray950.color
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.xClose.image, for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.textAlignment = .left
        $0.font = DSKitFontFamily.Pretendard.bold.font(size: 18)
        $0.text = "nn기 솝레터"
    }
    
    private let rightButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .center
    }
    
    private let downloadButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icDownload.image, for: .normal)
    }
    
    private let menuButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icSoptletterSubject.image, for: .normal)
    }
    
    private let reportButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icReport.image, for: .normal)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = DSKitAsset.Colors.gray950.color
        $0.showsVerticalScrollIndicator = false
        $0.clipsToBounds = false
    }
    
    private let writeButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.soptletterButton.image, for: .normal)
        $0.backgroundColor = DSKitAsset.Colors.gray10.color
        $0.layer.cornerRadius = 28
    }
    
    private let bannerImageButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.imgSoptletteraBanner.image, for: .normal)
    }
    
    private let placeHolderImageView = UIButton().then {
        $0.setImage(DSKitAsset.Assets.imgSoptletterPlaceholder.image, for: .normal)
        $0.isHidden = true
    }
            
    private let viewModel: SoptletterMainViewModel
    private let cancelBag = CancelBag()
    private let postItCellTapPublisher = PassthroughSubject<(messageId: Int, topicId: Int), Never>()
    private let naviBackButtonTapPublisher = PassthroughSubject<Void, Never>()
    
    private var soptletterMessages: SoptletterItemModel?
    
    private lazy var closeButtonTap: Driver<Void> = closeButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    private lazy var writeButtonTap: Driver<Void> = writeButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    private lazy var downloadButtonTap: Driver<Void> = downloadButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    private lazy var menuButtonTap: Driver<Void> = menuButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    private lazy var reportButtonTap: Driver<Void> = reportButton
        .publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    // MARK: - LifeCycles
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()        
        bindViewModels()
        setCollectionView()
    }
    
    public init(viewModel: SoptletterMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SoptletterMainVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.gray950.color
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bindViewModels() {
        let input = SoptletterMainViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            naviBackButtonTap: closeButtonTap,
            writeButtonTap: writeButtonTap,
            downloadButtonTap: downloadButtonTap,
            reportButtonTap: reportButtonTap,
            menuButtonTap: menuButtonTap,
            postItCellTap: postItCellTapPublisher.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.soptletterMessages
            .withUnretained(self)
            .sink { owner, model in
                owner.soptletterMessages = model
                owner.configureUI(model)
                owner.placeHolderImageView.isHidden = !model.messages.isEmpty
                owner.collectionView.reloadData()
            }.store(in: cancelBag)
    }
    
    private func configureUI(title: String) {
        titleLabel.text = title
    }
    
    private func setLayout() {
        rightButtonStackView.addArrangedSubviews(downloadButton, reportButton, menuButton)
        navigationView.addSubviews(closeButton, titleLabel, rightButtonStackView)
        view.addSubviews(collectionView, navigationView, writeButton, placeHolderImageView)
        
        placeHolderImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(86)
            make.centerX.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(56)
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(closeButton.snp.trailing).offset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        rightButtonStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        menuButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        reportButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.size.equalTo(56)
        }
    }
}

extension SoptletterMainVC {
    private func configureUI(_ model: SoptletterItemModel) {
        titleLabel.text = model.title
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(160)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SoptletterMainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setCollectionView() {
        collectionView.register(SoptletterPostItCell.self, forCellWithReuseIdentifier: SoptletterPostItCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soptletterMessages?.messages.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SoptletterPostItCell.identifier,
            for: indexPath
        ) as? SoptletterPostItCell,
        let message = soptletterMessages?.messages[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configure(
            text: message.previewContent,
            textColor: .black,
            backgroundImage: DSKitAsset.Assets.icnPointGreenCenter.image,
            labelRotationAngle: CGFloat(message.rotationDegree),
            backgroundColorHex: message.colorCode,
            shapeType: message.shapeType
        )
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let soptletterMessages else { return }
        let message = soptletterMessages.messages[indexPath.row]        
        postItCellTapPublisher.send((message.messageId, soptletterMessages.topicId))
    }
}
