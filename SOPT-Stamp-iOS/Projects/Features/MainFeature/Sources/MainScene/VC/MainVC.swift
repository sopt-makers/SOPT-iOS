//
//  MainVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import MainFeatureInterface
import StampFeatureInterface

public class MainVC: UIViewController, MainViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: MainViewModel!
    public var factory: StampFeatureViewBuildable!
    
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    private let naviBar = MainNavigationBar()
    
    private lazy var collectionView: UICollectionView = {
      let cv = UICollectionView(frame: .zero, collectionViewLayout: self.getLayout())
      cv.isScrollEnabled = true
      cv.showsHorizontalScrollIndicator = false
      cv.showsVerticalScrollIndicator = false
      cv.contentInset = .zero
      cv.backgroundColor = .clear
      return cv
    }()
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.registerCells()
    }
}

// MARK: - UI & Layout

extension MainVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        view.addSubviews(naviBar)
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func getLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, env in
            return NSCollectionLayoutSection()
        })
    }
}

// MARK: - Methods

extension MainVC {
    private func bindViewModels() {
        let input = MainViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCells() {
        self.collectionView.register(MainServiceCVC.self, forCellWithReuseIdentifier: MainServiceCVC.className)
    }
}

// MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
