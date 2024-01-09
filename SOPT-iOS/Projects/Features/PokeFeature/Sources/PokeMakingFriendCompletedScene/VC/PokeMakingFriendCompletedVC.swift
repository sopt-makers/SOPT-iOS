//
//  PokeMakingFriendCompletedVC.swift
//  PokeFeature
//
//  Created by sejin on 12/25/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine
import Lottie
import SnapKit
import Then

import Core
import DSKit

import PokeFeatureInterface
import BaseFeatureDependency

public class PokeMakingFriendCompletedVC: UIViewController, PokeMakingFriendCompletedPresentable  {
    
    // MARK: - Properties
    
    private let friendName: String
  
    // MARK: - UI Components
    
    private let lottieView = LottieAnimationView(name: "highfive",
                                                 bundle: DSKitResources.bundle)
    
    private let descriptionLabel = UILabel().then {
        $0.font = UIFont.MDS.title5
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private lazy var containerStackView = UIStackView(arrangedSubviews: [lottieView, descriptionLabel]).then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .center
    }
    
    // MARK: - initialization
    
    init(friendName: String) {
        self.friendName = friendName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    // MARK: - Method

    private func setLottie() {
        lottieView.loopMode = .repeat(2)
        lottieView.contentMode = .scaleAspectFit
        lottieView.play { _ in
            self.lottieView.stop()
            self.dismiss(animated: false)
        }
    }
}

// MARK: - UI & Layout

extension PokeMakingFriendCompletedVC {
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.gray950.color.withAlphaComponent(0.8)
        setLottie()
        self.descriptionLabel.text = I18N.Poke.makingFriendCompleted(name: self.friendName)
    }
    
    private func setLayout() {
        self.view.addSubviews(containerStackView)
        
        lottieView.snp.makeConstraints { make in
            make.width.equalTo(108)
            make.height.equalTo(88)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(36)
        }
    }
}
