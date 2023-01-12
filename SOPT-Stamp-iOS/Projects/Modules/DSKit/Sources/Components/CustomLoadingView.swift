//
//  CustomLoadingView.swift
//  DSKit
//
//  Created by Junho Lee on 2023/01/12.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Combine
import UIKit

import Core

import SnapKit

public extension UIViewController {
    var isLoading: Bool {
        get { return CustomLoadingView.shared.isLoading }
        set(startLoading) {
            if startLoading {
                CustomLoadingView.shared.show(self.view)
            } else {
                CustomLoadingView.shared.hide()
            }
        }
    }
    
    func showLoading() {
        self.isLoading = true
    }
    
    func stopLoading() {
        self.isLoading = false
    }
}

public class CustomLoadingView: UIView {
    
    // MARK: - Properties
    
    public static let shared = CustomLoadingView()
    public var isLoading: Bool {
        return self.activityIndicator.isAnimating
    }
    
    // MARK: - UI Components
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.hidesWhenStopped = false
        activityIndicator.style = .large
        activityIndicator.tintColor = .white
        return activityIndicator
    }()
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension CustomLoadingView {
    private func configureUI() {
        self.addSubview(activityIndicator)
    }
    
    public func show(_ view: UIView) {
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.3, delay: 0.05) {
            self.backgroundColor = .black.withAlphaComponent(0.55)
        }
        
        self.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.activityIndicator.center = view.center
        self.layoutIfNeeded()
        self.activityIndicator.startAnimating()
    }
    
    public func hide(completion: (() -> Void)? = nil) {
        self.backgroundColor = .clear
        self.activityIndicator.stopAnimating()
        self.removeFromSuperview()
        completion?()
    }
}
