//
//  MyTicketsViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 03/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol MyTicketsDisplayLogic: class {
    func setup(interactor: MyTicketsInteraction)
    func setup(router: MyTicketsRouterProtocol)
}

final class MyTicketsViewController: UIViewController {
    private var interactor: MyTicketsInteraction?
    private var router: MyTicketsRouterProtocol?
}

extension MyTicketsViewController: MyTicketsDisplayLogic {
    func setup(interactor: MyTicketsInteraction) {
        self.interactor = interactor
    }
    
    func setup(router: MyTicketsRouterProtocol) {
        self.router = router
    }
}
