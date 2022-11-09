//
//  ShowToast.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import SnapKit

public extension UIViewController {
    func showToast(message: String) {
        Toast.show(message: message, controller: self)
    }
}

public class Toast {
    static func show(message: String, controller: UIViewController) {
        
        let toastContainer = UIView()
        let toastLabel = UILabel()
        
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastContainer.alpha = 1
        toastContainer.layer.cornerRadius = 5
        toastContainer.clipsToBounds = true
        toastContainer.isUserInteractionEnabled = false
        
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 13)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.sizeToFit()
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(toastLabel.frame.width + 20)
            $0.height.equalTo(toastLabel.frame.height + 20)
        }
        
        toastLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 1.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
