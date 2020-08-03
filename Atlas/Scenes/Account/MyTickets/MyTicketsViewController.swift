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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        setupViews()
        interactor?.viewDidFinishLoading()
    }
}

private extension MyTicketsViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.title = NSLocalizedString("myTickets", comment: "")
    }
}

extension MyTicketsViewController: MyTicketsDisplayLogic {
    func setup(interactor: MyTicketsInteraction) {
        self.interactor = interactor
    }
    
    func setup(router: MyTicketsRouterProtocol) {
        self.router = router
    }
}
