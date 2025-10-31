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

public protocol SOPTWebViewControllable: AnyObject {
    var vc: UIViewController { get }
    var webView: WKWebView { get }
}

public final class SOPTWebView: UIViewController, SOPTWebViewControllable {
    private enum Metric {
        static let navigationBarHeight = 44.f
    }
    
    private lazy var navigationBar = WebViewNavigationBar(frame: self.view.frame)
    public let webView: WKWebView
    public var vc: UIViewController { self }
    private let downloadManager: WKDownloadManager
    
    // MARK: Variables
    private let cancelbag = CancelBag()
    private var barrier = false
    
    public init(
        config: WebViewConfig = WebViewConfig(),
        startWith url: URL,
        downloadManager: WKDownloadManager = .default
    ) {
        let configuration = WKWebViewConfiguration().then {
            $0.allowsInlineMediaPlayback = config.allowsInlineMediaPlayback
            $0.mediaTypesRequiringUserActionForPlayback = config.mediaTypesRequiringUserActionForPlayback
        }
        
        if FeatureFlag.auth == .new {
            // refreshToken
            if !self.barrier,
               let refreshToken = UserDefaultKeyList.CoreAuth.refreshToken,
               let cookie = HTTPCookie(properties: [
                HTTPCookiePropertyKey.domain: "." + (url.rootDomain ?? "sopt.org"),
                HTTPCookiePropertyKey.name: "Refresh-Token",
                HTTPCookiePropertyKey.path: "/",
                HTTPCookiePropertyKey.value: refreshToken,
                HTTPCookiePropertyKey.secure: "TRUE",
                HTTPCookiePropertyKey.expires: Date().addingTimeInterval(60 * 60 * 24 * 14)
               ]) {
                configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
        }
        
        self.webView = WKWebView(frame: .zero, configuration: configuration).then {
            $0.allowsBackForwardNavigationGestures = config.allowsBackForwardNavigationGestures
        }
        self.downloadManager = downloadManager
        super.init(nibName: nil, bundle: nil)
        
        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("coder initializer doesn't implemented.")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        
        downloadManager.webVC = self
        self.initializeViews()
        self.setupConstraints()
        self.setupNavigationButtonActions()
        self.setDelegate()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setGestureDelegate()
    }
}

extension SOPTWebView {
    private func initializeViews() {
        self.view.addSubviews(self.navigationBar, self.webView)
    }
    
    private func setupConstraints() {
        self.navigationBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.navigationBarHeight)
        }
        
        self.webView.snp.makeConstraints {
            $0.top.equalTo(self.navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationButtonActions() {
        self.navigationBar
            .signalForClickLeftButton()
            .sink { [weak self] _ in
                guard self?.webView.canGoBack == true else {
                    self?.navigationController?.popViewController(animated: true)
                    return
                }
                    
                self?.webView.goBack()
            }.store(in: self.cancelbag)
        
        self.navigationBar
            .signalForClickRightButton()
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: self.cancelbag)
    }
    
    private func setDelegate() {
        self.webView.scrollView.delegate = self
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
    }
}

extension SOPTWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        switch FeatureFlag.auth {
        case .legacy:
            guard !self.barrier,
                    let playgroundToken = UserDefaultKeyList.Auth.playgroundToken else {
                return
            }
            self.barrier = true
            self.webView.evaluateJavaScript(
                "localStorage.setItem(\"serviceAccessToken\", \"\(playgroundToken)\")"
            )
            
        case .new:
            guard !self.barrier,
            let accessToken = UserDefaultKeyList.CoreAuth.accessToken else { return }
            self.barrier = true
            self.webView.evaluateJavaScript(
                "localStorage.setItem(\"serviceAccessToken\", \"\(accessToken)\")"
            )
        }
        
        self.webView.reload()
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

extension SOPTWebView: WKDownloadDelegate {
    
    public func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String) async -> URL? {
        return await downloadManager.download(
            download,
            decideDestinationUsing: response,
            suggestedFilename: suggestedFilename
        )
    }
    
    public func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
    
    public func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = self
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SOPTWebView: UIGestureRecognizerDelegate {
    private func setGestureDelegate() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
