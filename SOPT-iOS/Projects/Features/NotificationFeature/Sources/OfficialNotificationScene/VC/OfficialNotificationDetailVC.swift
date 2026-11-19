//
//  OfficialNotificationDetailVC.swift
//  NotificationFeature
//
//  Created by 이나연 on 11/19/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import SwiftUI

import Core
import Domain
import MDS
import DSKit

import BaseFeatureDependency
import NotificationFeatureInterface

final class OfficialNotificationDetailVC: UIViewController {
    // MARK: - UI Components
    private lazy var naviBar = OPNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Notification.notification)
    
    private let hostingController: UIHostingController<OfficialNotificationDetailView>
    
    // MARK: - initialization
    
    public init(
        rootView: OfficialNotificationDetailView
    ) {
        self.hostingController = UIHostingController(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(naviBar)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        view.backgroundColor = SemanticColor.Bg.Layer.basement
        
        naviBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        hostingController.view.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
