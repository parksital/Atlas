//
//  AppDelegate.swift
//  Atlas
//
//  Created by Parvin Sital on 21/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit
import Swinject
import SwinjectAutoregistration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let container: Container! = {
        Container(parent: AWSContainer.shared.container)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupDependencies()
        let rootViewController = container.resolve(EventListViewController.self)!
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func setupDependencies() {
        container.autoregister(EventService.self, initializer: EventService.init)
        container.autoregister(EventListInteraction.self, initializer: EventListInteractor.init)
        container.autoregister(EventListPresentationLogic.self, initializer: EventListPresenter.init)
        container.autoregister(EventListRouterProtocol.self, initializer: EventListRouter.init)
        
        container.register(EventListViewController.self) { r in
            EventListViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(EventListInteraction.self)!
            let router = r.resolve(EventListRouterProtocol.self)!
            let presenter = r.resolve(EventListPresentationLogic.self)!
            
            vc.setup(interactor: interactor)
            vc.setup(router: router)
            
            router.setup(dataStore: interactor)
            router.setup(viewController: vc)
            
            presenter.setup(viewController: vc)
        }
    }
}
