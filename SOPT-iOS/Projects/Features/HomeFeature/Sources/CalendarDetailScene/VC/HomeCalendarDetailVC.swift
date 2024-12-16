//
//  HomeCalendarDetailVC.swift
//  HomeFeatureDemo
//
//  Created by 강윤서 on 12/12/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import DSKit
import Core

final class HomeCalendarDetailVC: UIViewController, HomeCalendarDetailViewControllable {

    // MARK: Properties
    
    public let viewModel: HomeCalendarDetailViewModel
    
    // MARK: UI Components
    
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
    
    private let gradationView = UIView().then {
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradientLayer = gradationView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradationView.bounds
        }
    }
}

// MARK: - UI & Layout

extension HomeCalendarDetailVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, gradationView, attendanceButton)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)          // navigation 추가 후 변경
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        gradationView.snp.makeConstraints { make in
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
}

extension HomeCalendarDetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.calendarDetailList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCalendarDetailCVC.className, for: indexPath) as? HomeCalendarDetailCVC else { return UICollectionViewCell() }
        
        cell.configureCell(viewModel.calendarDetailList[indexPath.row])
        
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
