//
//  PokeProfileImageView.swift
//  PokeFeature
//
//  Created by sejin on 12/5/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import DSKit

extension CustomProfileImageView {
    public func setImage(with url: String, relation: PokeRelation) {
        self.setImage(with: url, placeholder: DSKitAsset.Assets.iconDefaultProfile.image)
        self.setBorderColor(for: relation)
    }
    
    @discardableResult
    public func setBorderColor(for relation: PokeRelation) -> Self {
        self.layer.borderWidth = relation == .nonFriend ? 0 : 2
        self.layer.borderColor = relation.color.cgColor
        return self
    }
}
