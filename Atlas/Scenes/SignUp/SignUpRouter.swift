//
//  SignUpRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

@objc protocol SignUpRouting {
    func dismiss()
    func setup(viewController: SignUpViewController)
}

protocol SignUpDataPassing {
    var dataStore: SignUpDataStore? { get }
    func setup(dataStore: SignUpDataStore)
}

typealias SignUpRouterProtocol = NSObject & SignUpRouting & SignUpDataPassing
final class SignUpRouter: SignUpRouterProtocol {
    var dataStore: SignUpDataStore?
    private weak var viewController: SignUpViewController?
    
    func dismiss() {
        if let vc = viewController {
            DispatchQueue.main.async {
                vc.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setup(dataStore: SignUpDataStore) {
        self.dataStore = dataStore
    }
    
    func setup(viewController: SignUpViewController) {
        self.viewController = viewController
    }
}
