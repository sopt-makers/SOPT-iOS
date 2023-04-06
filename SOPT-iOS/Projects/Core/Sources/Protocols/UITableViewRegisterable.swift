//
//  UITableViewRegisterable.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

/// 필요한 셀에 TVC.register(target: tableView 이름) 형태로 등록
/// - isFromNib이 true인 경우, xib로 tableViewCell 생성한 것
/// - isFromNib이 false인 경우, 코드로 tableViewCell 생성한 것
public protocol UITableViewRegisterable {
    static var isFromNib: Bool { get }
    static func register(target: UITableView)
}

public protocol UITableViewHeaderFooterRegisterable {
    static var isFromNib: Bool { get }
    static func register(target: UITableView)
}

extension UITableViewRegisterable where Self: UITableViewCell {
    public static func register(target: UITableView) {
        if self.isFromNib {
            target.register(UINib(nibName: Self.className, bundle: nil), forCellReuseIdentifier: Self.className)
        } else {
            target.register(Self.self, forCellReuseIdentifier: Self.className)
        }
    }
}

extension UITableViewHeaderFooterRegisterable where Self: UITableViewHeaderFooterView {
    public static func register(target: UITableView) {
        if self.isFromNib {
            target.register(UINib(nibName: Self.className, bundle: nil), forHeaderFooterViewReuseIdentifier: Self.className)
        } else {
            target.register(Self.self, forHeaderFooterViewReuseIdentifier: Self.className)
        }
    }
}
