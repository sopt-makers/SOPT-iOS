//
//  setImage.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Kingfisher

public extension UIImageView {
    func setImage(with urlString: String, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        guard let urlString = urlString
            .removePercentEncodingIfNeeded()
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) 
        else {
            print("URL 인코딩 실패")
            return
        }

        let cache = ImageCache.default
        if urlString == "" {
            self.image = placeholder
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
    
    private func setNewImage(with urlString: String, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        
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
