//
//  EventDetailSectionHeader.swift
//  Atlas
//
//  Created by Parvin Sital on 05/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol SupplementaryKind {
    static var elementKind: String { get }
}

final class EventDetailSectionHeader: UICollectionReusableView, SupplementaryKind {
    static var elementKind = UICollectionView.elementKindSectionHeader
    
    
}

extension EventDetailSectionHeader {
    func configure(title: String?) {
        
    }
}
