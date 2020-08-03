//
//  HistoryRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 03/08/2020.
//  Copyright (c) 2020 Parvin Sital. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol HistoryRouting {
    func setup(viewController: HistoryViewController)
}

protocol HistoryDataPassing {
    var dataStore: HistoryDataStore? { get }
    func setup(dataStore: HistoryDataStore)
}
typealias HistoryRouterProtocol = NSObject
    & HistoryRouting
    & HistoryDataPassing

class HistoryRouter: HistoryRouterProtocol {
    weak var viewController: HistoryViewController?
    var dataStore: HistoryDataStore?
    
    func setup(viewController: HistoryViewController) {
        self.viewController = viewController
    }
    
    func setup(dataStore: HistoryDataStore) {
        self.dataStore = dataStore
    }
}
