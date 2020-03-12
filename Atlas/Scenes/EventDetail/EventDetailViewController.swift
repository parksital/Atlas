//
//  EventDetailViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol EventDetailDisplayLogic: class {
    func displayEventDetails(event: String)
}

final class EventDetailViewController: UIViewController {
    var interactor: EventDetailLogic?
    var router: (NSObjectProtocol & EventDetailRouting & EventDetailDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        setupViews()
        interactor?.viewDidFinishLoading()
    }
}

private extension EventDetailViewController {
    func setup() {
        let viewController = self
        let presenter = EventDetailPresenter()
        let interactor = EventDetailInteractor()
        let router = EventDetailRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setupViews() {
        view.backgroundColor = .white
    }
}

extension EventDetailViewController: EventDetailDisplayLogic {
    func displayEventDetails(event: String) {
        navigationItem.title = event
    }
}
