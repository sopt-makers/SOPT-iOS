//
//  SOPTWebView.swift
//  BaseFeatureDependency
//
//  Created by Ian on 11/30/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import DSKit

import UIKit
import WebKit

import SnapKit

public final class SOPTWebView: UIViewController {
    private enum Metric {
        static let navigationBarHeight = 44.f
    }
    
    private lazy var navigationBar = WebViewNavigationBar(frame: self.view.frame)
    private let wkwebView: WKWebView
    
    // MARK: Variables
    private let cancelbag = CancelBag()
    private var barrier = false
    
    public init(
        config: WebViewConfig = WebViewConfig(),
        startWith url: URL
    ) {
        let configuration = WKWebViewConfiguration().then {
            $0.allowsInlineMediaPlayback = config.allowsInlineMediaPlayback
            $0.mediaTypesRequiringUserActionForPlayback = config.mediaTypesRequiringUserActionForPlayback
        }
        
        self.wkwebView = WKWebView(frame: .zero, configuration: configuration).then {
            $0.allowsBackForwardNavigationGestures = config.allowsBackForwardNavigationGestures
        }
        
        super.init(nibName: nil, bundle: nil)
        
        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            self.wkwebView.load(request)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("coder initializer doesn't implemented.")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        
        self.wkwebView.scrollView.delegate = self
        self.wkwebView.navigationDelegate = self
        self.wkwebView.uiDelegate = self
        
        self.initializeViews()
        self.setupConstraints()
        self.setupNavigationButtonActions()
    }
}

extension SOPTWebView {
    private func initializeViews() {
        self.view.addSubviews(self.navigationBar, self.wkwebView)
    }
    
    private func setupConstraints() {
        self.navigationBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.navigationBarHeight)
        }
        
        self.wkwebView.snp.makeConstraints {
            $0.top.equalTo(self.navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationButtonActions() {
        self.navigationBar
            .signalForClickLeftButton()
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: self.cancelbag)
        
        self.navigationBar
            .signalForClickRightButton()
            .sink { [weak self] _ in
                self?.wkwebView.reload()
            }.store(in: self.cancelbag)
    }
}

extension SOPTWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !self.barrier else { return }
        
        self.barrier = true
        self.wkwebView.evaluateJavaScript(
            "localStorage.setItem(\"serviceAccessToken\", \"\(UserDefaultKeyList.Auth.playgroundToken!)\")"
        )
        self.wkwebView.reload()
    }
}

extension SOPTWebView: WKUIDelegate {
    public func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
}

extension SOPTWebView: UIScrollViewDelegate {
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
