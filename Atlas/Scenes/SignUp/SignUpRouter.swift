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

final class SignUpRouter: SignUpRouting {
    private weak var viewController: SignUpViewController?
    
    func dismiss() {
        if let vc = viewController {
            vc.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func setup(viewController: SignUpViewController) {
        self.viewController = viewController
    }
}
