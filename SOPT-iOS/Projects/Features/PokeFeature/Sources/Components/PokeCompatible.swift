//
//  PokeCompatible.swift
//  PokeFeature
//
//  Created by sejin on 12/24/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain

protocol PokeCompatible {
    func changeUIAfterPoke(newUserModel: PokeUserModel)
}
