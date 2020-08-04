//
//  MyTicketsDI.swift
//  Atlas
//
//  Created by Parvin Sital on 03/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Swinject

class MyTicketsDI {
    static func setDependencies(inContainer container: Container) {
        container.autoregister(MyTicketsInteraction.self, initializer: MyTicketsInteractor.init)
        container.autoregister(MyTicketsPresentationLogic.self, initializer: MyTicketsPresenter.init)
        container.autoregister(MyTicketsRouterProtocol.self, initializer: MyTicketsRouter.init)
        container.register(MyTicketsViewController.self) { r in
            MyTicketsViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(MyTicketsInteraction.self)!
            let router = r.resolve(MyTicketsRouterProtocol.self)!
            let presenter = r.resolve(MyTicketsPresentationLogic.self)!
            
            vc.setup(interactor: interactor)
            vc.setup(router: router)

            
            router.setup(dataStore: interactor)
            router.setup(viewController: vc)
            
            presenter.setup(viewController: vc)
        }
    }
}
