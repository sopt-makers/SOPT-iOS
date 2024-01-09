//
//  PokeNotificationContentCell.swift
//  PokeFeature
//
//  Created by Ian on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//


import Combine
import UIKit

import Core
import DSKit
import Domain

public final class PokeNotificationContentCell: UITableViewCell {
    private enum Metric {
        static let contentTopBottom = 10.f
        static let contentLeadingTrailing = 20.f
      
        static let bottomSeperatorHeight = 1.f
    }
    
    private lazy var notificationListContentView = PokeNotificationListContentView(frame: self.frame)
  
    private lazy var dividerView = UIView().then {
      $0.backgroundColor = DSKitAsset.Colors.gray700.color
    }
    
    // MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initializeViews()
        self.setupConstraints()
        
        // TBD: 읽은 알림 안읽은 알림 backgroundColor 처리
        self.contentView.backgroundColor = DSKitAsset.Colors.gray900.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) var cancelBag = CancelBag()
    
    public override func prepareForReuse() {
        self.cancelBag = CancelBag()
    }
}

extension PokeNotificationContentCell {
    private func initializeViews() {
      self.contentView.addSubviews(self.notificationListContentView, self.dividerView)
    }
    
    private func setupConstraints() {
        self.notificationListContentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Metric.contentTopBottom)
            $0.leading.trailing.equalToSuperview().inset(Metric.contentLeadingTrailing)
        }
      
        self.dividerView.snp.makeConstraints {
          $0.height.equalTo(Metric.bottomSeperatorHeight)
          $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension PokeNotificationContentCell {
    public func configure(with model: PokeUserModel) {
        self.notificationListContentView.configure(with: model)
    }
    
    public func signalForClick() -> Driver<PokeUserModel> {
        self.notificationListContentView.signalForPokeButtonClicked()
    }
}
