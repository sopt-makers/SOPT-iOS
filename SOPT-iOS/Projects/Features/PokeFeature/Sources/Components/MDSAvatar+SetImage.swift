//
//  MDSAvatar+SetImage.swift
//  PokeFeature
//
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

extension MDSAvatar {
    // NOTE: extension에는 저장 프로퍼티를 둘 수 없어 연관 객체로 마지막 요청 URL을 저장
    private struct AssociatedKey {
        static var currentURL: UInt8 = 0
    }
    
    func setImage(with urlString: String) {
        // NOTE: 셀 재사용 시 이전 요청이 늦게 끝나 현재 이미지를 덮어쓰지 않도록, 완료 시점에 마지막 요청 URL과 같을 때만 반영
        objc_setAssociatedObject(self, &AssociatedKey.currentURL, urlString, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.image = nil
        
        let loader = UIImageView()
        loader.setImage(with: urlString) { [weak self] image in
            guard let self,
                  objc_getAssociatedObject(self, &AssociatedKey.currentURL) as? String == urlString
            else { return }
            self.image = image
        }
    }
}
