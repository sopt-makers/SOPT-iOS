//
//  AttendanceCodeView.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

final class AttendanceCodeView: UIView {
    private enum Metric {
        static let itemHeight = 60.f
        static let itemWidth = 42.f
    }
    
    // MARK: - Properties
    
    private let totalCodeCount = 5
    
    // MARK: - UI Components
    
    var codeTextFields: [OPAttendanceCodeTextField] = []
    
    private lazy var codeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension AttendanceCodeView {
    private func setUI() {
        for idx in 0..<totalCodeCount {
            let textField = OPAttendanceCodeTextField.init()
            textField.tag = idx
            codeTextFields.append(textField)
            codeStackView.addArrangedSubview(textField)
        }
    }
    
    private func setLayout() {
        addSubview(codeStackView)
        
        codeStackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(Metric.itemHeight)
                $0.width.equalTo(Metric.itemWidth)
            }
        }
        
        codeStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
