//
//  MissionListCVC.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import SnapKit

@frozen
enum MissionListCellType {
    case levelOne(completed: Bool)
    case levelTwo(completed: Bool)
    case levelThree(completed: Bool)
}

final class MissionListCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    private var cellType: MissionListCellType = .levelOne(completed: false)
    
    // MARK: - UI Components
    
    private let stampImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let starView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let purposeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - View Life Cycles
    
    convenience init(_ type: MissionListCellType) {
        self.init()
        self.cellType = type
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension MissionListCVC {
    
    private func setUI() {
        
    }
    
    private func setLayout() {
        switch cellType {
        case .levelOne(completed: let completed):
            self.setLevelOneLayout(completed)
        case .levelTwo(completed: let completed):
            self.setLevelTwoLayout(completed)
        case .levelThree(completed: let completed):
            self.setLevelThreeLayout(completed)
        }
    }
    
    private func setLevelOneLayout(_ completed: Bool) {

    }
    
    private func setLevelTwoLayout(_ completed: Bool) {
        
    }
    
    private func setLevelThreeLayout(_ completed: Bool) {
        
    }
}

// MARK: - Methods

extension MissionListCVC {
    
    public func setData(model: String) {
        
    }
}

