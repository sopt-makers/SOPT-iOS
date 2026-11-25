//
//  ImageZoomInVC.swift
//  NotificationFeature
//
//  Created by 이나연 on 11/19/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import SwiftUI

import Core
import Domain
import DSKit

import BaseFeatureDependency
import NotificationFeatureInterface

final class ImageZoomInVC: UIViewController {
    private let imageUrl: String

    private lazy var hostingController = UIHostingController(
        rootView: ImageZoomInView(
            imageUrl: imageUrl,
            onClose: { [weak self] in self?.dismiss(animated: true) }
        )
    )

    // MARK: - initialization

    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        view.backgroundColor = .clear
        hostingController.view.backgroundColor = .clear

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
