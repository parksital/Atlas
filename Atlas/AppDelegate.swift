//
//  AppDelegate.swift
//  Atlas
//
//  Created by Parvin Sital on 21/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var container: Container!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupDependencies()
        
        guard let rootViewController = container.resolve(EventListViewOutputProtocol.self) as? EventListViewController else {
            fatalError("no EventListViewController found")
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func setupDependencies() {
        container = Container()
        
        container.register(EventListViewOutputProtocol.self, factory: { r in
            guard let interactor = r.resolve(EventListInteractionProtocol.self) else {
                fatalError("EventListOutput implementation not registered")
            }
            
            return EventListViewController(interactor: interactor)
        })
        
        container.register(EventListPresentationProtocol.self, factory: { _ in EventListPresenter() })
            .initCompleted { r, p in
                var presenter = p
                presenter.view = r.resolve(EventListViewOutputProtocol.self)
        }
        
        container.register(EventListInteractionProtocol.self, factory: { r in
            guard let presenter = r.resolve(EventListPresentationProtocol.self) else {
                fatalError("EventListPresentationProtocol implementation not registerd")
            }
            
            guard let service = r.resolve(EventFetchingProtocol.self) else {
                fatalError("EventFetching implementation not registered")
            }
            
            return EventListInteractor(presenter: presenter, eventService: service)
        })
        
        container.register(APIClient.self, factory: { _ in AWSClient() })

        container.register(EventFetchingProtocol.self, factory: { r in
            guard let client = r.resolve(APIClient.self) else {
                fatalError("APIClient implementation not found")
            }
            return EventService(client: client)
        })
    }
}

