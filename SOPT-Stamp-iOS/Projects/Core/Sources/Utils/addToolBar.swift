//
//  addToolBar.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    public func addToolbar(textfields: [UITextField]) {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnDoneBar = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.dismissKeyBoard))
        toolBarKeyboard.items = [flexSpace, btnDoneBar]
        for (_, item) in textfields.enumerated() {
            item.inputAccessoryView = toolBarKeyboard
        }
    }
    
    public func addToolBar(textView: UITextView) {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnDoneBar = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.dismissKeyBoard))
        toolBarKeyboard.items = [flexSpace, btnDoneBar]
        toolBarKeyboard.tintColor = UIColor.red
        textView.inputAccessoryView = toolBarKeyboard
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    public func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
    }
}
