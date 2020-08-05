//
//  UICollectionView+.swift
//  Atlas
//
//  Created by Parvin Sital on 04/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<C: UICollectionViewCell>(cellType: C.Type) {
        register(C.self, forCellWithReuseIdentifier: String(describing: C.self))
    }
    
    func getCell<C: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> C {
        return dequeueReusableCell(
            withReuseIdentifier: String(describing: C.self),
            for: indexPath
            ) as? C ?? C()
    }
}
