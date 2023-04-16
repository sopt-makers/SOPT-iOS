//
//  AssosiatedObject+UITabGesture.swift
//  AppMyPageFeature
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

extension UIView {
    typealias GestureHandler = (() -> Void)?
    
    private struct GestureAssociatedKey {
        fileprivate static var tapGestureKey = "_tabGestureKey"
    }
    
    private var tapGestureRecognizerHandler: GestureHandler? {
        get {
            return objc_getAssociatedObject(
                self,
                &GestureAssociatedKey.tapGestureKey
            ) as? GestureHandler
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &GestureAssociatedKey.tapGestureKey,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    public func addTapGestureRecognizer(_ handler: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerHandler = handler
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture)
        )
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerHandler {
            action?()
        }
    }
}

