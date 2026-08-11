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
import MDS
import Domain

public final class SoptletterMainVC: UIViewController, SoptletterViewControllable {

    // MARK: - UI Properties

    private let navigationView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Layer.basement
    }

    private let closeButton = UIButton().then {
        $0.setImage(MDSIcon.xCloseOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
    }

    private let titleLabel = UILabel().then {
        $0.text = "nn기 솝레터"
        $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
        $0.textAlignment = .left
    }

    private let rightButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = BaseSpacing.Base.s12
        $0.alignment = .center
    }

    private let downloadButton = UIButton().then {
        $0.setImage(MDSIcon.downloadOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
    }

    private let menuButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.icSoptletterSubject.image, for: .normal)
    }

    private let reportButton = UIButton().then {
        $0.setImage(MDSIcon.alertTriangleOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = SemanticColor.Bg.Layer.basement
        $0.showsVerticalScrollIndicator = false
        $0.clipsToBounds = false
    }

    private let writeButton = MDSFloatingButton(size: .default, icon: MDSIcon.writeOutlined.image)

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
    private let imagePreviewPublisher = PassthroughSubject<(fileName: String, image: UIImage, url: URL), Never>()
    private let soptletterHeaderPublisher = PassthroughSubject<Int, Never>()
    private let isRoot: Bool

    private var soptletterMessages: SoptletterItemModel?
    private var snapshotDataSource: SnapshotPostItDataSource?
    private var ctaModel: SoptletterCTAModel?

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

    private lazy var soptletterHeaderTap: Driver<Int> = soptletterHeaderPublisher
        .asDriver()

    // MARK: - LifeCycles

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModels()
        setCollectionView()
    }

    public init(viewModel: SoptletterMainViewModel, isRoot: Bool) {
        self.viewModel = viewModel
        self.isRoot = isRoot
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SoptletterMainVC {
    private func setUI() {
        view.backgroundColor = SemanticColor.Bg.Layer.basement
        navigationController?.setNavigationBarHidden(true, animated: false)

        closeButton.setImage(
            (isRoot ? MDSIcon.xCloseOutlined.image : MDSIcon.chevronLeftOutlined.image)
                .withTintColor(SemanticColor.Fg.Neutral.bold),
            for: .normal
        )
        menuButton.isHidden = !isRoot
    }

    private func bindViewModels() {
        let input = SoptletterMainViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            naviBackButtonTap: closeButtonTap,
            writeButtonTap: writeButtonTap,
            downloadButtonTap: downloadButtonTap,
            reportButtonTap: reportButtonTap,
            menuButtonTap: menuButtonTap,
            postItCellTap: postItCellTapPublisher.asDriver(),
            imageProcessCompleted: imagePreviewPublisher.asDriver(),
            soptletterHeaderTap: soptletterHeaderTap.asDriver()
        )

        let output = self.viewModel.transform(from: input, cancelBag: cancelBag)

        output.soptletterMessages
            .withUnretained(self)
            .sink { owner, model in
                owner.soptletterMessages = model
                owner.configureUI(model)
                owner.placeHolderImageView.isHidden = !model.messages.isEmpty
                owner.downloadButton.isHidden = model.messages.isEmpty
                owner.collectionView.reloadData()
            }.store(in: cancelBag)

        output.onDownloadConfirm
            .withUnretained(self)
            .sink { owner, _ in
                Task { @MainActor in
                    ToastUtils.showMDSToast(type: .alert, text: "이미지 미리보기 생성 중...")

                    await Task.yield()

                    let previewImage = owner.makeSoptletterSnapshotImage()
                    guard let pdfURL = owner.makeSoptletterPDFFileURL(fileName: owner.title ?? "soptletter") else {
                        ToastUtils.showMDSToast(type: .error, text: "이미지 미리보기 생성 실패")
                        return
                    }
                    owner.imagePreviewPublisher.send((owner.titleLabel.text ?? "soptletter", previewImage, pdfURL))
                }
            }.store(in: cancelBag)

        output.ctaInfo
            .withUnretained(self)
            .sink { owner, model in
                owner.ctaModel = model
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
            make.centerY.equalTo(closeButton.snp.centerY)
        }

        rightButtonStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(closeButton.snp.centerY)
        }

        [downloadButton, menuButton, reportButton].forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        writeButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(BaseSpacing.Base.s20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(BaseSpacing.Base.s24)
        }
    }
}

extension SoptletterMainVC {
    private func configureUI(_ model: SoptletterItemModel) {
        titleLabel.text = model.title
        titleLabel.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
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
        section.interGroupSpacing = BaseSpacing.Base.s10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: BaseSpacing.Base.s16, bottom: BaseSpacing.Base.s10, trailing: 16)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(64)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SoptletterMainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setCollectionView() {
        collectionView.register(SoptletterPostItCell.self, forCellWithReuseIdentifier: SoptletterPostItCell.identifier)
        collectionView.register(
            SoptletterBannerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SoptletterBannerHeaderView.identifier
        )
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
            textColor: SemanticColor.Fg.Neutral.inverse,
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

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SoptletterBannerHeaderView.identifier,
                for: indexPath
              ) as? SoptletterBannerHeaderView else {
            return UICollectionReusableView()
        }

        let shouldHideBanner = !isRoot || !(ctaModel?.showCta ?? false)

        headerView.configure(
            ctaText: ctaModel?.ctaText ?? "",
            isHidden: shouldHideBanner,
            onTap: { [weak self] in
                guard let topicId = self?.ctaModel?.topicId else { return }
                self?.soptletterHeaderPublisher.send(topicId)
            }
        )

        return headerView
    }
}

// MARK: - PDF Snapshot

extension SoptletterMainVC {

    func makeSoptletterSnapshotImage() -> UIImage {
        let allMessages = soptletterMessages?.messages ?? []
        let displayMessages = Array(allMessages.prefix(16))

        let columns = 2
        let itemHeight: CGFloat = 160
        let itemSpacing: CGFloat = 6
        let sideInset: CGFloat = 8
        let bottomInset: CGFloat = 10

        let width: CGFloat = view.bounds.width > 0 ? view.bounds.width : UIScreen.main.bounds.width

        let rows = Int(ceil(Double(displayMessages.count) / Double(columns)))
        let totalHeight = CGFloat(rows) * itemHeight + CGFloat(max(rows - 1, 0)) * itemSpacing + bottomInset

        let layout = makePostItGridLayout(
            itemHeight: itemHeight,
            itemSpacing: itemSpacing,
            sideInset: sideInset,
            bottomInset: bottomInset
        )

        let snapshotFrame = CGRect(x: 0, y: 0, width: width, height: totalHeight)
        let snapshotCollectionView = UICollectionView(frame: snapshotFrame, collectionViewLayout: layout)
        snapshotCollectionView.backgroundColor = SemanticColor.Bg.Layer.basement
        snapshotCollectionView.isScrollEnabled = false
        snapshotCollectionView.register(SoptletterPostItCell.self, forCellWithReuseIdentifier: SoptletterPostItCell.identifier)

        let dataSource = SnapshotPostItDataSource(messages: displayMessages)
        self.snapshotDataSource = dataSource
        snapshotCollectionView.dataSource = dataSource

        view.addSubview(snapshotCollectionView)
        snapshotCollectionView.frame.origin = CGPoint(x: -10000, y: 0)

        snapshotCollectionView.reloadData()
        snapshotCollectionView.layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(bounds: snapshotCollectionView.bounds)
        let image = renderer.image { context in
            snapshotCollectionView.layer.render(in: context.cgContext)
        }

        snapshotCollectionView.removeFromSuperview()
        self.snapshotDataSource = nil

        return image
    }
}

// MARK: - SnapshotPostItDataSource

final class SnapshotPostItDataSource: NSObject, UICollectionViewDataSource {

    private let messages: [SoptletterMessageModel]

    init(messages: [SoptletterMessageModel]) {
        self.messages = messages
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SoptletterPostItCell.identifier,
            for: indexPath
        ) as? SoptletterPostItCell else {
            return UICollectionViewCell()
        }

        let message = messages[indexPath.item]
        cell.configure(
            text: message.previewContent,
            textColor: SemanticColor.Fg.Neutral.inverse,
            backgroundImage: DSKitAsset.Assets.icnPointGreenCenter.image,
            labelRotationAngle: CGFloat(message.rotationDegree),
            backgroundColorHex: message.colorCode,
            shapeType: message.shapeType
        )

        return cell
    }
}


extension SoptletterMainVC {

    func makeSoptletterPDFData() -> Data {
        let allMessages = soptletterMessages?.messages ?? []

        let columns = 2
        let itemHeight: CGFloat = 160
        let itemSpacing: CGFloat = 6
        let sideInset: CGFloat = 8
        let bottomInset: CGFloat = 10
        let titleAreaHeight: CGFloat = 56

        let width: CGFloat = view.bounds.width > 0 ? view.bounds.width : UIScreen.main.bounds.width

        let rows = Int(ceil(Double(allMessages.count) / Double(columns)))
        let gridHeight = CGFloat(rows) * itemHeight + CGFloat(max(rows - 1, 0)) * itemSpacing + bottomInset
        let totalHeight = titleAreaHeight + gridHeight

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: totalHeight))
        containerView.backgroundColor = SemanticColor.Bg.Layer.basement

        let pdfTitleLabel = UILabel().then {
            $0.textColor = SemanticColor.Fg.Neutral.bold
            $0.textAlignment = .left
            $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
            $0.text = soptletterMessages?.title ?? titleLabel.text
        }
        containerView.addSubview(pdfTitleLabel)
        pdfTitleLabel.frame = CGRect(x: 16, y: 16, width: width - 32, height: 24)

        let layout = makePostItGridLayout(
            itemHeight: itemHeight,
            itemSpacing: itemSpacing,
            sideInset: sideInset,
            bottomInset: bottomInset
        )

        let gridFrame = CGRect(x: 0, y: titleAreaHeight, width: width, height: gridHeight)
        let pdfCollectionView = UICollectionView(frame: gridFrame, collectionViewLayout: layout)
        pdfCollectionView.backgroundColor = .clear
        pdfCollectionView.isScrollEnabled = false
        pdfCollectionView.register(SoptletterPostItCell.self, forCellWithReuseIdentifier: SoptletterPostItCell.identifier)

        // dataSource는 weak 참조라 강하게 들고 있어야 함 (snapshotDataSource 프로퍼티 재사용)
        let dataSource = SnapshotPostItDataSource(messages: allMessages)
        self.snapshotDataSource = dataSource
        pdfCollectionView.dataSource = dataSource

        containerView.addSubview(pdfCollectionView)

        view.addSubview(containerView)
        containerView.frame.origin = CGPoint(x: -10000, y: 0)

        pdfCollectionView.reloadData()
        pdfCollectionView.layoutIfNeeded()
        containerView.layoutIfNeeded()

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: containerView.bounds)
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            containerView.layer.render(in: context.cgContext)
        }

        containerView.removeFromSuperview()
        self.snapshotDataSource = nil

        return pdfData
    }

    func makeSoptletterPDFFileURL(fileName: String = "soptletter") -> URL? {
        let pdfData = makeSoptletterPDFData()
        let tmpURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(fileName)-\(UUID().uuidString).pdf")

        do {
            try pdfData.write(to: tmpURL, options: .atomic)
            return tmpURL
        } catch {
            print("PDF 저장 실패: \(error)")
            return nil
        }
    }
}
