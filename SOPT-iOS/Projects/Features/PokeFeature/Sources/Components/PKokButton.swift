//
//  PKokButton.swift
//  PokeFeature
//
//  Created by Jae Hyun Lee on 10/3/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import MDS

public final class PKokButton: UIButton {
    
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
        let backgroundColor = isEnabled ? SemanticColor.Bg.Neutral.inverse : SemanticColor.Bg.Neutral.Bold.disabled
        self.backgroundColor = backgroundColor
    }
    
    private func setIcon() {
        // TODO: - MDS에 추가하기
        let icon = DSKitAsset.Assets.icKok.image
        self.setImage(icon.withTintColor(SemanticColor.Fg.Neutral.inverse), for: .normal)
        self.setImage(icon.withTintColor(SemanticColor.Fg.Neutral.Default.disabled), for: .disabled)
    }
}
