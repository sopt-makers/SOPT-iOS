//
//  ActionButtonView+SwiftUI.swift
//  NotificationFeature
//
//  Created by 이나연 on 11/25/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import SwiftUI
import UIKit

import MDS

struct ActionButtonView: UIViewRepresentable {

    // MARK: - Properties

    let title: String
    var variant: MDSActionButton.Variant
    var size: MDSActionButton.Size
    let action: () -> Void

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> MDSActionButton {
        MDSActionButton(variant: variant, size: size)
    }

    func updateUIView(_ button: MDSActionButton, context: Context) {
        button.title = title
        button.isEnabled = context.environment.isEnabled

        // 같은 identifier의 액션은 교체되므로 중복 등록되지 않음
        let tapAction = UIAction(identifier: .init("ActionButtonView.tap")) { _ in action() }
        button.addAction(tapAction, for: .touchUpInside)
    }
}

