//
//  MissionListVC.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine
import SnapKit
import Then

import SettingFeatureInterface
import StampFeatureInterface

public class MissionListVC: UIViewController, MissionListViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: MissionListViewModel!
    public var factory: (SettingFeatureViewBuildable & StampFeatureViewBuildable)!
    public var sceneType: MissionListSceneType {
        return self.viewModel.missionListsceneType
    }
    private var cancelBag = CancelBag()
    
    private var missionTypeMenuSelected = CurrentValueSubject<MissionListFetchType, Never>(.all)
    private var viewWillAppear = PassthroughSubject<Void, Never>()
    private let swipeHandler = PassthroughSubject<Void, Never>()
    
    lazy var dataSource: UICollectionViewDiffableDataSource<MissionListSection, MissionListModel>! = nil
    
    // MARK: - UI Components
    
    lazy var naviBar: STNavigationBar = {
        switch sceneType {
        case .default:
            return STNavigationBar(self, type: .title)
                .setTitle("전체 미션")
                .setTitleTypoStyle(.SoptampFont.h2)
                .setTitleButtonMenu(menuItems: self.menuItems)
        case .ranking(let username, _):
            return STNavigationBar(self, type: .titleWithLeftButton)
                .setTitle(username)
                .setRightButton(.none)
                .setTitleTypoStyle(.SoptampFont.h2)
        }
    }()
    
    private lazy var menuItems: [UIAction] = {
        var menuItems: [UIAction] = []
        [("전체 미션", MissionListFetchType.all),
         ("완료 미션", MissionListFetchType.complete),
         ("미완료 미션", MissionListFetchType.incomplete)].forEach { menuTitle, fetchType in
            menuItems.append(UIAction(title: menuTitle,
                                      handler: { _ in
                self.missionTypeMenuSelected.send(fetchType)
                self.naviBar.setTitle(menuTitle)
            }))
        }
        return menuItems
    }()
    
    private lazy var sentenceLabel: SentencePaddingLabel = {
        let lb = SentencePaddingLabel()
        if case let .ranking(_, sentence) = sceneType {
            lb.text = sentence
        }
        lb.setTypoStyle(.SoptampFont.subtitle1)
        lb.textColor = DSKitAsset.Colors.soptampGray900.color
        lb.numberOfLines = 2
        lb.textAlignment = .center
        lb.backgroundColor = DSKitAsset.Colors.soptampPurple100.color
        lb.layer.cornerRadius = 9.adjustedH
        lb.clipsToBounds = true
        lb.setCharacterSpacing(0)
        return lb
    }()
    
    private lazy var missionListCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        cv.showsVerticalScrollIndicator = true
        cv.backgroundColor = .white
        cv.bounces = false
        return cv
    }()
    
    private let missionListEmptyView = MissionListEmptyView()
    
    private lazy var rankingFloatingButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 27.adjustedH
        bt.backgroundColor = DSKitAsset.Colors.soptampPurple300.color
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .normal)
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .highlighted)
        bt.tintColor = .white
        bt.titleLabel?.setTypoStyle(.SoptampFont.h2)
        let attributedStr = NSMutableAttributedString(string: "랭킹 보기")
        let style = NSMutableParagraphStyle()
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedStr.length))
        bt.setAttributedTitle(attributedStr, for: .normal)
        bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        bt.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return bt
    }()
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.setGesture()
        self.registerCells()
        self.setDataSource()
        self.bindViews()
        self.bindViewModels()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppear.send(())
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - UI & Layouts

extension MissionListVC {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, missionListCollectionView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        missionListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(20.adjustedH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        switch sceneType {
        case .default:
            self.view.addSubview(rankingFloatingButton)
            
            rankingFloatingButton.snp.makeConstraints { make in
                make.width.equalTo(143.adjusted)
                make.height.equalTo(54.adjustedH)
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-18.adjustedH)
                make.centerX.equalToSuperview()
            }
        case .ranking:
            self.view.addSubview(sentenceLabel)
            
            sentenceLabel.snp.makeConstraints { make in
                make.top.equalTo(naviBar.snp.bottom).offset(10.adjustedH)
                make.leading.trailing.equalToSuperview().inset(20.adjusted)
                make.height.equalTo(64.adjustedH)
            }
            
            missionListCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(sentenceLabel.snp.bottom).offset(16.adjustedH)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - Methods

extension MissionListVC {
    private func bindViews() {
        
        naviBar.rightButtonTapped
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.pushToGuideVC()
            }.store(in: self.cancelBag)
        
        rankingFloatingButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                owner.pushToRankingVC()
            }.store(in: self.cancelBag)
        
        swipeHandler
            .first()
            .withUnretained(self)
            .sink { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.store(in: self.cancelBag)
    }
    
    private func bindViewModels() {
        let input = MissionListViewModel.Input(viewWillAppear: viewWillAppear.asDriver(),
                                               missionTypeSelected: missionTypeMenuSelected)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$missionListModel
            .compactMap { $0 }
            .sink { model in
                self.setCollectionView(model: model)
            }.store(in: self.cancelBag)
    }
    
    private func pushToGuideVC() {
//        let settingVC = factory.makeSettingVC().viewController
        let guideVC = factory.makeStampGuideVC().viewController
        self.navigationController?.pushViewController(guideVC, animated: true)
    }
    
    private func pushToRankingVC() {
        let rankingVC = factory.makeRankingVC().viewController
        self.navigationController?.pushViewController(rankingVC, animated: true)
    }
}

extension MissionListVC {
    
    private func setDelegate() {
        missionListCollectionView.delegate = self
    }
    
    private func setGesture() {
        self.setGesture(to: missionListCollectionView)
        self.setGesture(to: missionListEmptyView)
    }
    
    private func setGesture(to view: UIView) {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeBack(_:)))
        swipeGesture.delegate = self
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc
    private func swipeBack(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self.view)
        let velocityMinimum: CGFloat = 1000
        guard let navigation = self.navigationController else { return }
        let isScrollY: Bool = abs(velocity.x) > abs(velocity.y) + 200
        let isNotRootView = navigation.viewControllers.count >= 2
        if velocity.x >= velocityMinimum
            && isNotRootView
            && isScrollY {
            self.missionListCollectionView.isScrollEnabled = false
            swipeHandler.send(())
        }
    }
    
    private func registerCells() {
        MissionListCVC.register(target: missionListCollectionView)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: missionListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch MissionListSection.type(indexPath.section) {
            case .sentence:
                guard let sentenceCell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCVC.className, for: indexPath) as? MissionListCVC else { return UICollectionViewCell() }
                return sentenceCell
                
            case .missionList:
                guard let missionListCell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCVC.className, for: indexPath) as? MissionListCVC else { return UICollectionViewCell() }
                let missionListModel = itemIdentifier
                missionListCell.initCellType = missionListModel.toCellType()
                missionListCell.setData(model: missionListModel)
                return missionListCell
            }
        })
    }
    
    func setCollectionView(model: [MissionListModel]) {
        if model.isEmpty {
            self.missionListCollectionView.isHidden = true
            self.missionListEmptyView.isHidden = false
            self.setEmptyView()
        } else {
            self.missionListCollectionView.isHidden = false
            self.missionListEmptyView.isHidden = true
            self.applySnapshot(model: model)
        }
    }
    
    private func setEmptyView() {
        missionListEmptyView.snp.removeConstraints()
        missionListEmptyView.removeFromSuperview()
        self.view.addSubviews(missionListEmptyView)
        missionListEmptyView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(145.adjustedH)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
        bringRankingFloatingButtonToFront()
    }
    
    private func bringRankingFloatingButtonToFront() {
        self.view.subviews.forEach { view in
            if view == self.rankingFloatingButton {
                self.view.bringSubviewToFront(rankingFloatingButton)
            }
        }
    }
    
    private func applySnapshot(model: [MissionListModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<MissionListSection, MissionListModel>()
        snapshot.appendSections([.sentence, .missionList])
        snapshot.appendItems(model, toSection: .missionList)
        dataSource.apply(snapshot, animatingDifferences: false)
        self.view.setNeedsLayout()
    }
}

// MARK: - UICollectionViewDelegate

extension MissionListVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        case 1:
            switch self.sceneType {
            case .default:
                return true
            case .ranking:
                return true
            }
        default:
            return false
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            guard let tappedCell = collectionView.cellForItem(at: indexPath) as? MissionListCVC,
                  let model = tappedCell.model,
                  let starLevel = StarViewLevel.init(rawValue: model.level)else { return }
            let sceneType = model.toListDetailSceneType()
            
            let detailVC = factory.makeListDetailVC(sceneType: sceneType,
                                                    starLevel: starLevel,
                                                    missionId: model.id,
                                                    missionTitle: model.title,
                                                    isOtherUser: true).viewController
            self.navigationController?.pushViewController(detailVC, animated: true)
        default:
            return
        }
    }
}

extension MissionListVC: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
