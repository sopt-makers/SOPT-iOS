//
//  MissionCompletedVC.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/05.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import Lottie
import SnapKit
import Then

import Core
import DSKit

import StampFeatureInterface

extension StarViewLevel {
    fileprivate var lottieName: String {
        switch self {
        case .levelOne:
            return "pinkstamps"
        case .levelTwo:
            return "purplestamp"
        case .levelThree:
            return "greenstamp"
        }
    }
}

public class MissionCompletedVC: UIViewController, MissionCompletedViewControllable {
    
    // MARK: - Properties
    
    private var starLevel: StarViewLevel!
    private var cancelBag = CancelBag()
    public var completionHandler: (() -> Void)?
  
    // MARK: - UI Components
    
    private lazy var lottieView = LottieAnimationView(name: starLevel.lottieName, bundle: DSKitResources.bundle, configuration: LottieConfiguration(renderingEngine: .automatic))
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    // MARK: - Method
    
    @discardableResult
    public func setLevel(_ level: StarViewLevel) -> Self {
        self.starLevel = level
        return self
    }
    
    private func setLottie() {
        lottieView.center = view.center
        lottieView.loopMode = .playOnce
        lottieView.contentMode = .scaleAspectFit
        lottieView.play {_ in
            self.lottieView.stop()
            self.dismiss(animated: true) {
                self.completionHandler?()
            }
        }
    }
}

// MARK: - UI & Layout

extension MissionCompletedVC {
    private func setUI() {
        self.view.backgroundColor = .clear
        setLottie()
    }
    
    private func setLayout() {
        self.view.addSubviews(lottieView)
        
        lottieView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(lottieView.snp.width).multipliedBy(0.85)
        }
    }
}
