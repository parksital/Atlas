//
//  CollectionView+.swift
//  Atlas
//
//  Created by Parvin Sital on 23/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerCell<C: UICollectionViewCell & ConfigurableCell>(cell: C.Type) {
        self.register(C.self, forCellWithReuseIdentifier: C.id)
    }
    
    func dequeueCell<C: UICollectionViewCell & ConfigurableCell>(
        atIndexPath indexPath: IndexPath
    ) -> C {
        return self.dequeueReusableCell(
            withReuseIdentifier: C.id,
            for: indexPath
            ) as? C ?? C()
    }
}
