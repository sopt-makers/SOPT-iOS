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
        .setCornerRadius(10)
        .setPlaceholder("영문, 숫자, 특수문자 포함 N자 이상 입력해주세요.")
        .setTextFieldType(.password)
    
    let tf2 = CustomTextFieldView(type: .subTitle)
        .setCornerRadius(12)
        .setSubTitle("ID")
        .setPlaceholder("영문, 숫자, 특수문자 포함 N자 이상 입력해주세요.")
        .setAlertLabelEnabled()
        .setAlertLabel("사용 중인 이름입니다.")

    let tf3 = CustomTextFieldView(type: .titleWithRightButton)
        .setCornerRadius(10)
        .setTitle("닉네임")
        .setPlaceholder("한글/영문 NN자로 입력해주세요.")
        .setAlertLabelEnabled()
        .setAlertLabel("사용 중인 이름입니다.")
    
    let btn = CustomButton(title: "로그인")
        .setEnabled(true)
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubviews(tf1, tf2, tf3, btn)
        
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
        
        btn.snp.makeConstraints { make in
            make.top.equalTo(tf3.snp.bottom).offset(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56)
        }
    }
}
