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

extension StarViewLevel {
    var lottieName: String {
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

public class MissionCompletedVC: UIViewController {
    
    // MARK: - Properties
    
    private var starLevel: StarViewLevel!
    private var cancelBag = CancelBag()
    private let blurEffect = UIBlurEffect(style: .dark)
    var completionHandler: (() -> Void)?
  
    // MARK: - UI Components
    
    private lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)
    private lazy var lottieView = LottieAnimationView(name: starLevel.lottieName)
  
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
        // FIXME: - lottie json 파일을 찾지 못하는 문제
        lottieView.backgroundColor = .yellow
        lottieView.center = view.center
        lottieView.loopMode = .playOnce
        lottieView.contentMode = .scaleAspectFit
        
        self.lottieView.play { _ in
            self.lottieView.stop()
            print("zdjlskgjdlk")
            self.dismiss(animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
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
        self.view.addSubviews(visualEffectView, lottieView)
        
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lottieView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(lottieView.snp.width).multipliedBy(0.85)
        }
    }
}
