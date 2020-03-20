//
//  EventDetailRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

@objc protocol EventDetailRouting {
    
}

protocol EventDetailDataPassing {
    var dataStore: EventDetailDataStore? { get }
}

final class EventDetailRouter: NSObject, EventDetailRouting, EventDetailDataPassing {
    weak var viewController: EventDetailViewController?
    var dataStore: EventDetailDataStore?
}
