//
//  UITableView+.swift
//  Atlas
//
//  Created by Parvin Sital on 29/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

extension UITableView {
    func register<C: UITableViewCell>(cellType: C.Type) {
        register(C.self, forCellReuseIdentifier: String(describing: C.self))
    }
    
    func getCell<C: UITableViewCell>(forIndexPath indexPath: IndexPath) -> C {
        return dequeueReusableCell(
            withIdentifier: String(describing: C.self),
            for: indexPath
            ) as? C ?? C()
    }
}
