//
//  HomeCalendarDetailVC.swift
//  HomeFeatureDemo
//
//  Created by 강윤서 on 12/12/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency
import DailySoptuneFeatureInterface

final class HomeCalendarDetailVC: UIViewController, HomeCalendarDetailViewControllable {

    // MARK: Properties
    
    public let viewModel: HomeCalendarDetailViewModel
    private var cancelBag = CancelBag()
    private var calendarDetailInfo: [HomeCalendarDetailPresentationModel]?
    
    // MARK: UI Components
    
    private lazy var naviBar = OPNavigationBar(self,
                                               type: .oneLeftButton,
                                               backgroundColor: DSKitAsset.Colors.semanticBackground.color)
        .addMiddleLabel(title: I18N.Home.CalendarDetail.navigationTitle, font: DSKitFontFamily.Suit.medium.font(size: 16))
    
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 138, right: 0)
        $0.backgroundColor = .clear
    }
    
    private let attendanceButton = AppCustomButton(title: I18N.Home.CalendarDetail.attendance)
                                    .changeCornerRadius(radius: 12)
                                    .setConfigForState(enabledFont: DSKitFontFamily.Suit.semiBold.font(size: 18))
    
    private let gradientView = UIView().then {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [DSKitAsset.Colors.black.color.withAlphaComponent(0.0).cgColor, DSKitAsset.Colors.black.color.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        $0.layer.addSublayer(gradientLayer)
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Initialization
    
    init(viewModel: HomeCalendarDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setDelegate()
        registerCells()
        bindViewModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }
        
        scrollToRecentSchedule()
    }
}

// MARK: - UI & Layout

extension HomeCalendarDetailVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, collectionView, gradientView, attendanceButton)
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(209.adjustedH)
        }
        
        attendanceButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(56)
        }
    }
}

// MARK: - Methods

extension HomeCalendarDetailVC {
    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func registerCells() {
        collectionView.register(HomeCalendarDetailCVC.self, forCellWithReuseIdentifier: HomeCalendarDetailCVC.className)
    }
    
    private func bindViewModels() {
        let input = HomeCalendarDetailViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(), 
            naviBackButtonTap: self.naviBar.leftButtonTapped.asDriver(), 
            onAttendanceButtonTap: self.attendanceButton
                .publisher(for: .touchUpInside)
                .withUnretained(self)
                .mapVoid()
                .asDriver()
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.calendarDetailModel
            .withUnretained(self)
            .sink { owner, calendarDetailInfo in
                owner.calendarDetailInfo = calendarDetailInfo
                owner.collectionView.reloadData()
            }.store(in: cancelBag)
            
    }
    
    private func scrollToRecentSchedule() {
        if let index = self.calendarDetailInfo?.firstIndex(where: {$0.isRecentSchedule}) {
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                             at: .top,
                                        animated: true)
        }
    }
}

extension HomeCalendarDetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.calendarDetailInfo?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCalendarDetailCVC.className, for: indexPath) as? HomeCalendarDetailCVC else { return UICollectionViewCell() }
        
        cell.configureCell(self.calendarDetailInfo?[safe: indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = self.collectionView.frame.size.width
        return CGSize(width: length, height: 96.adjustedH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
