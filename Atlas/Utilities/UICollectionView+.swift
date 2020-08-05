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
    
    func register<E: UICollectionReusableView & SupplementaryKind>(
        supplementaryElement: E.Type
    ) {
        self.register(
            E.self,
            forSupplementaryViewOfKind: E.elementKind,
            withReuseIdentifier: String(describing: E.self
            )
        )
    }
    
    func getCell<C: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> C {
        return dequeueReusableCell(
            withReuseIdentifier: String(describing: C.self),
            for: indexPath
            ) as? C ?? C()
    }
    
    func getSupplementaryView<E: UICollectionReusableView & SupplementaryKind>(
        ofType type: E.Type,
        forIndexPath indexPath: IndexPath
    ) -> UICollectionReusableView? {
        return dequeueReusableSupplementaryView(
            ofKind: E.elementKind,
            withReuseIdentifier: String(describing: E.self),
            for: indexPath
        )
    }
}
