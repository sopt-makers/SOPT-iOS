//
//  setImage.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Kingfisher

public extension UIImageView {
    func setImage(with urlString: String, placeholder: String? = nil, completion: ((UIImage?) -> Void)? = nil) {
        let cache = ImageCache.default
        if urlString == "" {
            // URL 빈 이미지로 넘겨 받았을 경우, 아래에 UIImage에 기본 사진을 추가 하면 된다.
            self.image = UIImage()
        } else {
            cache.retrieveImage(forKey: urlString) { result in
                result.success { imageCache in
                    if let image = imageCache.image {
                        self.image = image
                        completion?(image)
                    } else {
                        self.setNewImage(with: urlString, placeholder: placeholder, completion: completion)
                    }
                }.catch { _ in
                    self.setNewImage(with: urlString, placeholder: placeholder, completion: completion)
                }
            }
        }
    }
    
    private func setNewImage(with urlString: String, placeholder: String? = "img_placeholder", completion: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        let placeholderImage = UIImage(named: "img_placeholder")
        let placeholder = placeholderImage
        
        self.kf.setImage(
            with: resource,
            placeholder: placeholder,
            options: [
                .scaleFactor(UIScreen.main.scale/4),
                .transition(.fade(0.5)),
                .cacheMemoryOnly
            ],
            completionHandler: { result in
                result.success { imageResult in
                    completion?(imageResult.image)
                }
            }
        )
    }
}
