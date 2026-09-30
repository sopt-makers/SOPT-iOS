//
//  PokeProfileImageView.swift
//  PokeFeature
//
//  Created by sejin on 12/5/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import MDS

extension MDSAvatar {
    func setImage(with url: String, relation: PokeRelation) {
        self.setImage(with: url)
        self.setStroke(for: relation)
    }
    
    @discardableResult
    func setStroke(for relation: PokeRelation) -> Self {
        self.hasStroke = relation != .nonFriend
        self.strokeColor = relation.color
        return self
    }
}
