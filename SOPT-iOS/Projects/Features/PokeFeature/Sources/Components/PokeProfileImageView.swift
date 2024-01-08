//
//  PokeProfileImageView.swift
//  PokeFeature
//
//  Created by sejin on 12/5/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import DSKit

/// 테두리가 있는 원형 프로필 이미지 뷰
public final class PokeProfileImageView: UIImageView {
    
    // MARK: - Properties
    
    lazy var tap = self.gesture().mapVoid().asDriver()
    
    // MARK: - initialization
    
    public init() {
        super.init(frame: .zero)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray700.color
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.contentMode = .scaleAspectFill
    }
    
    public func setImage(with url: String, relation: PokeRelation) {
        self.setImage(with: url, placeholder: DSKitAsset.Assets.iconDefaultProfile.image)
        self.setBorderColor(for: relation)
    }
    
    @discardableResult
    public func setBorderColor(for relation: PokeRelation) -> Self {
        self.layer.borderColor = relation.color.cgColor
        return self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
}
