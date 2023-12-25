//
//  ShowToast.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit

public extension UIViewController {
    @available(*, deprecated, message: "Use MDS toast")
    func showToast(message: String) {
        Toast.show(message: message, view: self.view, safeAreaBottomInset: self.safeAreaBottomInset())
    }
    
    func showMDSToast(type: MDSToast.ToastType, text: String, linkButtonAction: (() -> Void)? = nil) {
        Toast.showMDSToast(type: type, text: text, linkButtonAction: linkButtonAction)
    }
}

public class Toast {
    public static func show(
        message: String,
        view: UIView,
        safeAreaBottomInset: CGFloat = UIWindow.keyWindowGetter?.safeAreaInsets.bottom ?? 0
    ) {
        
        let toastContainer = UIView()
        let toastLabel = UILabel()
        
        toastContainer.backgroundColor = DSKitAsset.Colors.soptampGray600.color
        toastContainer.alpha = 1
        toastContainer.layer.cornerRadius = 10
        toastContainer.clipsToBounds = true
        toastContainer.isUserInteractionEnabled = false
        
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.setTypoStyle(.SoptampFont.caption1)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.sizeToFit()
        
        toastContainer.addSubview(toastLabel)
        view.addSubview(toastContainer)
        
        toastContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(safeAreaBottomInset+40)
            $0.width.equalTo(213)
            $0.height.equalTo(44)
        }
        
        toastLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 1.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    public static func showMDSToast(type: MDSToast.ToastType, text: String, linkButtonAction: (() -> Void)? = nil) {
        let toast = MDSToast(type: type, text: text, linkButtonAction: linkButtonAction)
        
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        guard let window = scene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        window.addSubview(toast)
        
        let toastHeight = 48.f
        
        let toastStartingInset = window.safeAreaInsets.top + toastHeight
        
        toast.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(window.safeAreaLayoutGuide).inset(-toastStartingInset)
        }
        
        UIView.animate(withDuration: 0.5) {
            toast.transform = CGAffineTransform(translationX: 0, y: toastStartingInset + 16.f)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 4.0, animations: {
                toast.transform = .identity
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
}
