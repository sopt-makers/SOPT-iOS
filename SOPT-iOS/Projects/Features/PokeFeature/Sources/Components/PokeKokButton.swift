//
//  PokeKokButton.swift
//  PokeFeature
//
//  Created by sejin on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core

public final class PokeKokButton: UIButton {
    
    // MARK: - Properties
    
    public var isFriend: Bool {
        didSet {
            setIcon()
        }
    }
    
    public lazy var tap: Driver<Void> = self.publisher(for: .touchUpInside)
        .mapVoid()
        .asDriver()
    
    public override var isEnabled: Bool {
        didSet {
            changeUI(with: isEnabled)
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    // MARK: - initialization
    
    public init(isFriend: Bool = true) {
        self.isFriend = isFriend
        super.init(frame: .zero)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.setIcon()
        self.layer.cornerRadius = 18
        self.changeUI(with: self.isEnabled)
    }
    
    private func changeUI(with isEnabled: Bool) {
        let backgroundColor = isEnabled ? DSKitAsset.Colors.gray10.color : DSKitAsset.Colors.gray700.color
        self.backgroundColor = backgroundColor
    }
    
    public func setIsFriend(with isFriend: Bool) {
        self.isFriend = isFriend
    }
    
    private func setIcon() {
        let icon = self.isFriend ? DSKitAsset.Assets.iconKok.image : DSKitAsset.Assets.iconEyes.image
        self.setImage(icon.withTintColor(DSKitAsset.Colors.black.color), for: .normal)
        self.setImage(icon.withTintColor(DSKitAsset.Colors.gray500.color), for: .disabled)
    }
}
