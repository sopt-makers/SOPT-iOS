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
            self.image = placeholder
            completion?(nil)
            return
        }
        
        // SVG 이미지일 경우 검사
        if urlString.lowercased().hasSuffix(".svg") {
            self.image = placeholder
            completion?(nil)
            return
        }
        
        let cache = ImageCache.default
        if urlString.isEmpty {
            self.image = placeholder
            completion?(nil)
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
        let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
                
        self.kf.setImage(
            with: resource,
            placeholder: placeholder,
            options: [
                .processor(DownsamplingImageProcessor(size: self.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheMemoryOnly
            ],
            completionHandler: { result in
                switch result {
                case .success(let imageResult):
                    completion?(imageResult.image)
                case .failure:
                    self.image = placeholder
                    completion?(nil)
                }
            }
        )
    }
}
