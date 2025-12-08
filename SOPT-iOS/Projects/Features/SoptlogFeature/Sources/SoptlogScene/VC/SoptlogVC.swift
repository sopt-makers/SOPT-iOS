//
//  SoptlogVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency

final class SoptlogVC: UIViewController, SoptlogViewControllable {
    
    // MARK: - Properties
    
    public let viewModel: SoptlogViewModel
    private let cancelBag = CancelBag()
    private var cellTap = PassthroughSubject<IndexPath, Never>()
    private var toolTipTap = PassthroughSubject<CGRect, Never>()
    private var viewWillAppear = PassthroughSubject<Void, Never>()
    private var soptlogInfo: SoptlogPresentationModel?
    internal var isPokeEmpty: Bool = true
    
    // MARK: - UI Components
    
    private lazy var naviBar = OPNavigationBar(self, type: .none)
        .addMiddleLabel(title: I18N.Soptlog.navigationTitle, font: DSKitFontFamily.Suit.medium.font(size: 16))
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    // MARK: - Initialization
    
    public init(viewModel: SoptlogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
        bindViewModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppear.send()
    }
}

// MARK: - UI & Layout

extension SoptlogVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, collectionView)
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension SoptlogVC {
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCells() {
        // 셀 등록
        self.collectionView.register(SoptlogMenuCVC.self, forCellWithReuseIdentifier: SoptlogMenuCVC.className)
        self.collectionView.register(SoptlogBannerCVC.self, forCellWithReuseIdentifier: SoptlogBannerCVC.className)
        self.collectionView.register(SoptlogImageCVC.self, forCellWithReuseIdentifier: SoptlogImageCVC.className)
        self.collectionView.register(SoptlogEmptyCVC.self, forCellWithReuseIdentifier: SoptlogEmptyCVC.className)
        
        // Header 등록
        self.collectionView.register(SoptlogSectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SoptlogSectionHeaderReusableView.className)
        
        // Footer 등록
        self.collectionView.register(SoptlogImageFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SoptlogImageFooterReusableView.className)
        
        // Decoration view 등록
        self.collectionView.collectionViewLayout.register(
            SoptlogSectionBackgroundDecorationView.self,
            forDecorationViewOfKind: SoptlogSectionBackgroundDecorationView.className
        )
    }

    private func bindViewModels() {
        let input = SoptlogViewModel.Input(
            viewWillAppear: viewWillAppear.asDriver(),
            cellTap: cellTap.asDriver(),
            toolTipButtonTap: toolTipTap.asDriver()
        )

        let output = viewModel.transform(from: input, cancelBag: cancelBag)

        output.soptlogInfo
            .receive(on: RunLoop.main)
            .withUnretained(self)
            .sink { owner, info in
                owner.soptlogInfo = info
                owner.collectionView.reloadData()
            }
            .store(in: cancelBag)
    }
}

// MARK: - UICollectionViewDelegate

extension SoptlogVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTap.send(indexPath)
    }
}

// MARK: - UICollectionViewDataSource
    
extension SoptlogVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SoptlogSectionLayoutKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = SoptlogSectionLayoutKind(rawValue: section),
              let info = soptlogInfo else { return 0 }

        switch sectionType {
        case .logo:
            return 1
        case .soptampLog:
            return info.soptampMenus.count
        case .pokeLog:
            return isPokeEmpty ? 1 : info.pokeMenus.count
        case .banner:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SoptlogSectionLayoutKind(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        guard let info = soptlogInfo else { return UICollectionViewCell() }
        
        switch section {
        case .logo:
            return configureLogoCell(at: indexPath)
            
        case .soptampLog:
            return configureMenuCell(at: indexPath, with: info.soptampMenus)
            
        case .pokeLog:
            if isPokeEmpty {
                return configureEmptyCell(at: indexPath)
            } else {
                return configureMenuCell(at: indexPath, with: info.pokeMenus)
            }
            
        case .banner:
            return configureBannerCell(at: indexPath, title: info.alarm.todayFortuneText)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionType = SoptlogSectionLayoutKind(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SoptlogSectionHeaderReusableView.className,
                for: indexPath
            ) as? SoptlogSectionHeaderReusableView else {
                return UICollectionReusableView()
            }
            
            let title = sectionType.title
            headerView.configure(title: title)
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            guard sectionType == .banner,
                  let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SoptlogImageFooterReusableView.className,
                    for: indexPath
                  ) as? SoptlogImageFooterReusableView else {
                return UICollectionReusableView()
            }
            
            footerView.configure(image: DSKitAsset.Assets.bottomSoptlog.image)
            return footerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    private func configureLogoCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SoptlogImageCVC.className,
            for: indexPath
        ) as? SoptlogImageCVC else {
            return UICollectionViewCell()
        }
        
        cell.configure(image: DSKitAsset.Assets.mainSoptlog.image)
        return cell
    }
    
    private func configureMenuCell(at indexPath: IndexPath, with menus: [SoptlogMenuModel]) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SoptlogMenuCVC.className,
            for: indexPath
        ) as? SoptlogMenuCVC else {
            return UICollectionViewCell()
        }
        
        let menu = menus[indexPath.row]
        let showSeparator = indexPath.row != menus.count - 1
        cell.configure(
            title: menu.title,
            value: menu.value,
            hasTooltip: menu.hasTooltip,
            hasChevron: menu.hasChevron,
            showSeparator: showSeparator
        )
        
        cell.toolTipButtonTapped
            .subscribe(toolTipTap)
            .store(in: cell.cancelBag)
        
        return cell
    }
    
    private func configureBannerCell(at indexPath: IndexPath, title: String) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SoptlogBannerCVC.className,
            for: indexPath
        ) as? SoptlogBannerCVC else {
            return UICollectionViewCell()
        }
        
        cell.configure(title: title)
        
        return cell
    }
    
    private func configureEmptyCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SoptlogEmptyCVC.className,
            for: indexPath
        ) as? SoptlogEmptyCVC else {
            return UICollectionViewCell()
        }

        cell.configure(text: I18N.Soptlog.Menu.pokeEmptyDescription)

        return cell
    }
}
