//
//  ShowToast.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

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
    
    public static func showMDSToast(type: MDSToast.ToastType, text: String, actionButtonAction: (() -> Void)? = nil) {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        guard let window = scene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let toast = MDSToast(type: type, text: text, actionButtonAction: actionButtonAction)
        
        // 토스트가 중복으로 나오지 않도록 방지
        let previousToast = window.subviews.first { $0 is MDSToast }
        previousToast?.removeFromSuperview()
        
        window.addSubview(toast)
        
        let toastHeight = 64.f
        let toastStartingInset = window.safeAreaInsets.top + toastHeight
        
        // 3단 animate로 구현 
        // toast의 넓이가 계산된 이후에 y 위치 변화를 해야 애니메이션이 자연스럽게 나온다. (completion 시점에 y 위치 변화 시켜야 함)
        
        UIView.animate(withDuration: 0.0) {
            // 1. 토스트의 처음 위치 잡기 (화면 상단 바깥 부분에 위치시킨다.)
            toast.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(window.safeAreaLayoutGuide).inset(-toastStartingInset)
            }
            toast.superview?.layoutIfNeeded()
        } completion: { _ in
            // 2. 토스트를 천천히 아래로 내린다. (화면에 등장)
            UIView.animate(withDuration: 0.4) {
                toast.snp.updateConstraints { make in
                    make.top.equalTo(window.safeAreaLayoutGuide).inset(16)
                }
                toast.superview?.layoutIfNeeded()
            } completion: { _ in
                // 3. 4초 후에 토스트를 천천히 위로 올린다. (화면에서 제거)
                /*
                 여기서 UIView.animate의 delay 옵션이 아닌 DispathQueue의 ascynAfter를 쓴 이유
                 -> delay로 주면 화면에는 4초 뒤에 토스트가 사라지지만 사실 toast의 위치는 애니메이션 시작 전에 이미 계산되어 화면 밖으로 인식됨
                 -> 토스트에 있는 버튼이 터치가 안 되는 문제 발생
                 -> asyncAfter를 사용하여 4초 뒤에 Constraints를 업데이트하도록 하여 문제 해결
                */
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 0.4, animations: {
                        toast.snp.updateConstraints { make in
                            make.top.equalTo(window.safeAreaLayoutGuide).inset(-toastStartingInset)
                        }
                        toast.superview?.layoutIfNeeded()
                    }) { _ in
                        toast.removeFromSuperview()
                    }
                }
            }
        }
    }
}
