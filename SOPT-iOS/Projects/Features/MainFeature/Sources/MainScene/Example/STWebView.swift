////
////  STWebView.swift
////  MainFeatureTests
////
////  Created by Ian on 10/28/23.
////  Copyright © 2023 SOPT-iOS. All rights reserved.
////
//
//import Core
//import DSKit
//import BaseFeatureDependency
//
//import UIKit
//import WebKit
//
//import SnapKit
//
//public struct WebViewConfig {
//  let javaScriptEnabled: Bool
//  let allowsBackForwardNavigationGestures: Bool
//  let allowsInlineMediaPlayback: Bool
//  let mediaTypesRequiringUserActionForPlayback: WKAudiovisualMediaTypes
//  let isScrollEnabled: Bool
//  
//  init(
//    javaScriptEnabled: Bool = true,
//    allowsBackForwardNavigationGestures: Bool = true,
//    allowsInlineMediaPlayback: Bool = true,
//    mediaTypesRequiringUserActionForPlayback: WKAudiovisualMediaTypes = [],
//    isScrollEnabled: Bool = true
//  ) {
//    self.javaScriptEnabled = javaScriptEnabled
//    self.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
//    self.allowsInlineMediaPlayback = allowsInlineMediaPlayback
//    self.mediaTypesRequiringUserActionForPlayback = mediaTypesRequiringUserActionForPlayback
//    self.isScrollEnabled = isScrollEnabled
//  }
//}
//
//public final class STWebView: UIViewController {
//  private lazy var navigationBar = OPNavigationBar(
//    self,
//    type: .oneLeftButton,
//    backgroundColor: DSKitAsset.Colors.black100.color,
//    ignoreLeftButtonAction: true
//  )
//    .addMiddleLabel(title: I18N.MyPage.navigationTitle)
//  
//  private let wkwebView: WKWebView
//  
//  init(
//    config: WebViewConfig = WebViewConfig(),
//    startWith url: URL
//  ) {
//    let configuration = WKWebViewConfiguration().then {
//      $0.allowsInlineMediaPlayback = config.allowsInlineMediaPlayback
//      $0.mediaTypesRequiringUserActionForPlayback = config.mediaTypesRequiringUserActionForPlayback
//    }
//    
//    self.wkwebView = WKWebView(frame: .zero, configuration: configuration)
//
//    super.init(nibName: nil, bundle: nil)
//
//    DispatchQueue.main.async {
//      let request = URLRequest(url: url)
//      self.wkwebView.load(request)
//    }
//  }
//  
//  public required init?(coder: NSCoder) {
//    fatalError("coder initializer doesn't implemented.")
//  }
//  
//  public override func loadView() {
//    super.loadView()
//
//  }
//  
//  public override func viewDidLoad() {
//    super.viewDidLoad()
//   
//    self.wkwebView.navigationDelegate = self
//    self.wkwebView.uiDelegate = self
//    
//    self.initializeViews()
//    self.setupConstraints()
//  }
//}
//
//extension STWebView {
//  private func initializeViews() {
//    self.view.addSubviews(self.navigationBar, self.wkwebView)
//  }
//  
//  private func setupConstraints() {
//    self.navigationBar.snp.makeConstraints {
//      $0.top.equalToSuperview()
//      $0.leading.trailing.equalToSuperview()
//      $0.height.equalTo(44.f)
//    }
//   
//    self.wkwebView.snp.makeConstraints {
//      $0.top.equalTo(self.navigationBar.snp.bottom)
//      $0.leading.trailing.bottom.equalToSuperview()
//    }
//  }
//}
//
//extension STWebView: WKNavigationDelegate {
//}
//
//extension STWebView: WKUIDelegate {
//  public func webView(
//    _ webView: WKWebView,
//    createWebViewWith configuration: WKWebViewConfiguration,
//    for navigationAction: WKNavigationAction,
//    windowFeatures: WKWindowFeatures
//  ) -> WKWebView? {
//    if navigationAction.targetFrame == nil {
//      webView.load(navigationAction.request)
//    }
//    
//    return nil
//  }
//}
