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
    
    public init() {
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
    
    private func setIcon() {
        let icon = DSKitAsset.Assets.iconKok.image
        self.setImage(icon.withTintColor(DSKitAsset.Colors.black.color), for: .normal)
        self.setImage(icon.withTintColor(DSKitAsset.Colors.gray500.color), for: .disabled)
    }
}
