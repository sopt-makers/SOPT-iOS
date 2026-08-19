//
//  MDSAvatar+SetImage.swift
//  StampFeature
//
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

extension MDSAvatar {
    func setImage(with urlString: String) {
        let loader = UIImageView()
        loader.setImage(with: urlString) { [weak self] image in
            self?.image = image
        }
    }
}
