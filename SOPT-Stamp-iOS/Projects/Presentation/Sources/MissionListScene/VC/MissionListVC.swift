//
//  MissionListVC.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

public class MissionListVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    public var viewModel: MissionListViewModel!
    public var sceneType: MissionListSceneType {
        return self.viewModel.missionListsceneType
    }
    private var cancelBag = CancelBag()
    
    lazy var dataSource: UICollectionViewDiffableDataSource<MissionListSection, AnyHashable>! = nil
    
    // MARK: - UI Components
    
    lazy var naviBar: CustomNavigationBar = {
        switch sceneType {
        case .default:
            return CustomNavigationBar(self, type: .title)
                .setTitle("전체 미션")
                .setTitleTypoStyle(.h2)
        case .ranking(let username):
            return CustomNavigationBar(self, type: .titleWithLeftButton)
                .setTitle(username)
                .setRightButton(.none)
                .setTitleTypoStyle(.h2)
        }
    }()
    
    private lazy var missionListCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        cv.showsVerticalScrollIndicator = true
        cv.backgroundColor = .white
        cv.bounces = false
        return cv
    }()
    
    private lazy var rankingFloatingButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 27.adjustedH
        bt.backgroundColor = DSKitAsset.Colors.purple300.color
        bt.setTitle("랭킹 보기", for: .normal)
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .normal)
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .highlighted)
        bt.tintColor = .white
        bt.titleLabel?.setTypoStyle(.h2)
        return bt
    }()
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.registerCells()
        self.bindViewModels()
        self.setDataSource()
        self.applySnapshot()
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
            make.top.equalTo(naviBar.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        if case .default = sceneType {
            self.view.addSubview(rankingFloatingButton)
            
            rankingFloatingButton.snp.makeConstraints { make in
                make.width.equalTo(143.adjusted)
                make.height.equalTo(54.adjustedH)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.centerX.equalToSuperview()
            }
        }
    }
}

// MARK: - Methods

extension MissionListVC {
    
    private func bindViewModels() {
        let input = MissionListViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
    private func setDelegate() {
        missionListCollectionView.delegate = self
    }
    
    private func registerCells() {
        MissionListCVC.register(target: missionListCollectionView)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: missionListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch MissionListSection.type(indexPath.section) {
            case .sentence:
                guard let sentenceCell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCVC.className, for: indexPath) as? MissionListCVC else { return UICollectionViewCell() }
                
                sentenceCell.initCellType = .levelOne(completed: true)
                return sentenceCell
                
            case .missionList:
                guard let missionListCell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCVC.className, for: indexPath) as? MissionListCVC else { return UICollectionViewCell() }
                guard let index = itemIdentifier as? Int else { return UICollectionViewCell() }
                switch index % 6 {
                case 0:
                    missionListCell.initCellType = .levelOne(completed: true)
                case 1:
                    missionListCell.initCellType = .levelOne(completed: false)
                case 2:
                    missionListCell.initCellType = .levelTwo(completed: false)
                case 3:
                    missionListCell.initCellType = .levelTwo(completed: true)
                case 4:
                    missionListCell.initCellType = .levelThree(completed: true)
                default:
                    missionListCell.initCellType = .levelThree(completed: false)
                }
                return missionListCell
            }
        })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MissionListSection, AnyHashable>()
        snapshot.appendSections([.sentence, .missionList])
        var tempItems: [Int] = []
        for i in 0..<50 {
            tempItems.append(i)
        }
        snapshot.appendItems(tempItems, toSection: .missionList)
        dataSource.apply(snapshot, animatingDifferences: false)
        self.view.setNeedsLayout()
    }
}

// MARK: - UICollectionViewDelegate

extension MissionListVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: - 확인용
        var sceneType: ListDetailSceneType = .none
        var level: StarViewLevel = .levelOne
        if indexPath.item % 2 == 0 {
            sceneType = .completed
        }
        
        if indexPath.item % 3 == 0 {
            level = .levelTwo
        } else if indexPath.item % 3 == 1 {
            level = .levelThree
        }
        let detailVC = factory.makeListDetailVC(sceneType: sceneType, starLevel: level, missionId: 3, missionTitle: "타이틀도 주세요 ..")
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
