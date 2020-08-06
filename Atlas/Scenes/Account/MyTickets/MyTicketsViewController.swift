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

final class MyTicketsViewController: UIViewController, HasLocalization {
    var tableName: String { return "MyTickets"}
    var localizationService: LocalizationService!
    
    private var interactor: MyTicketsInteraction?
    private var router: MyTicketsRouterProtocol?
    
    private let wipLabel = UILabel(styling: .primary)
    
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
        setupWIPLabel()
    }
    
    func setupNavigation() {
        navigationItem.title = localize("myTickets")
    }
    
    func setupWIPLabel() {
        wipLabel.text = "WIP"
        view.addSubview(wipLabel)
        wipLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = wipLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let centerX = wipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([centerY, centerX])
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
