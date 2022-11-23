//
//  TestVC.swift
//  PresentationTests
//
//  Created by sejin on 2022/11/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public class TestVC: UIViewController {
    
    let tf1 = CustomTextFieldView(type: .plain)
    let tf2 = CustomTextFieldView(type: .subTitle)
    let tf3 = CustomTextFieldView(type: .titleWithRightButton)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubviews(tf1, tf2, tf3)
        tf1.backgroundColor = .gray
        tf2.backgroundColor = .gray
        tf3.backgroundColor = .gray
        
        tf1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        tf2.snp.makeConstraints { make in
            make.top.equalTo(tf1.snp.bottom).offset(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        tf3.snp.makeConstraints { make in
            make.top.equalTo(tf2.snp.bottom).offset(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
