//
//  MyTicketsRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 03/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

@objc protocol MyTicketsRouting {
    func setup(viewController: MyTicketsViewController)
}

protocol MyTicketsDataPassing {
    func setup(dataStore: MyTicketsDataStore)
}
typealias MyTicketsRouterProtocol = NSObject
    & MyTicketsRouting
    & MyTicketsDataPassing
    
final class MyTicketsRouter: MyTicketsRouterProtocol {
    weak var viewController: MyTicketsViewController?
    var dataStore: MyTicketsDataStore?
    
    func setup(viewController: MyTicketsViewController) {
        self.viewController = viewController
    }
    
    func setup(dataStore: MyTicketsDataStore) {
        self.dataStore = dataStore
    }
    
    
}
