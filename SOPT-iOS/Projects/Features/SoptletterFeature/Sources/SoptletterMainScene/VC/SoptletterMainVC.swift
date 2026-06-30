//
//  SoptletterMainVC.swift
//  SoptletterFeature
//
//  Created by dev on 6/29/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import SnapKit

public final class SoptletterMainVC: UIViewController {
    
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
    
    // MARK: - API 연동시 실제 데이터로 변경 예정
    private let dummyData: [SoptletterDummy] = [
        SoptletterDummy(text: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 ", textColor: DSKitAsset.Colors.gray900.color, backgroundImage: DSKitAsset.Assets.icnCloudRedLeft.image, rotationDegree: -10),
        SoptletterDummy(text: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 ", textColor: DSKitAsset.Colors.gray900.color, backgroundImage: DSKitAsset.Assets.icnCloudBlueRight.image, rotationDegree: 10),
        SoptletterDummy(text: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 ", textColor: DSKitAsset.Colors.gray900.color, backgroundImage: DSKitAsset.Assets.icnPointRedLeft.image, rotationDegree: -10),
        SoptletterDummy(text: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 ", textColor: DSKitAsset.Colors.gray900.color, backgroundImage: DSKitAsset.Assets.icnCloudYellowCenter.image, rotationDegree: 0),
        SoptletterDummy(text: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 ", textColor: DSKitAsset.Colors.gray900.color, backgroundImage: DSKitAsset.Assets.icnPointGreenCenter.image, rotationDegree: 0),
        SoptletterDummy(text: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 ", textColor: DSKitAsset.Colors.gray900.color, backgroundImage: DSKitAsset.Assets.icnSmoothRedCenter.image, rotationDegree: 0),
    ]
    
    // MARK: - LifeCycles

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setCollectionView()
    }

    public init() {
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

    private func setLayout() {
        rightButtonStackView.addArrangedSubviews(downloadButton, reportButton)
        navigationView.addSubviews(closeButton, titleLabel, rightButtonStackView)
        view.addSubviews(collectionView, navigationView, writeButton)

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
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(180)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 9.5, bottom: 100, trailing: 9.5)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SoptletterMainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let dummy = dummyData[indexPath.item]

        let postItView = SoptletterPostItView()

        postItView.configure(
            text: dummy.text,
            textColor: dummy.textColor,
            backgroundImage: dummy.backgroundImage,
            labelRotationAngle: CGFloat(dummy.rotationDegree)
        )

        cell.clipsToBounds = false
        cell.contentView.clipsToBounds = false
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(postItView)
        postItView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = SoptletterDetailModalVC()
        detailVC.configure(
            name: "익명의 무무",
            content: dummyData[indexPath.item].text,
            date: "mm.dd",
            likeCount: 44
        )
        present(detailVC, animated: true)
    }
}



private struct SoptletterDummy {
    let text: String
    let textColor: UIColor
    let backgroundImage: UIImage?
    let rotationDegree: Int
}
