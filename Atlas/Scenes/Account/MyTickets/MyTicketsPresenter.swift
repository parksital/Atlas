//
//  MyTicketsPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 03/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
protocol MyTicketsPresentationLogic {
    func setup(viewController: MyTicketsDisplayLogic)
}

final class MyTicketsPresenter {
    weak var viewController: MyTicketsDisplayLogic?
}

extension MyTicketsPresenter: MyTicketsPresentationLogic {
    func setup(viewController: MyTicketsDisplayLogic) {
        self.viewController = viewController
    }
}
