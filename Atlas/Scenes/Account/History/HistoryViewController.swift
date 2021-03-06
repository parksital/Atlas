//
//  HistoryViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 03/08/2020.
//  Copyright (c) 2020 Parvin Sital. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HistoryDisplayLogic: class {
    func setup(interactor: HistoryInteraction)
    func setup(router: HistoryRouterProtocol)
}

final class HistoryViewController: UIViewController, HasLocalization {
    var tableName: String { return "History" }
    var localizationService: LocalizationService!
    
    var interactor: HistoryInteraction?
    var router: HistoryRouterProtocol?
    
    private let wipLabel = UILabel(styling: .primary)
    
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.viewDidFinishLoading()
    }
}

private extension HistoryViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupWIPLabel()
    }
    
    func setupNavigation() {
        navigationItem.title = localize("history")
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

extension HistoryViewController: HistoryDisplayLogic {
    func setup(interactor: HistoryInteraction) {
        self.interactor = interactor
    }
    func setup(router: HistoryRouterProtocol) {
        self.router = router
    }
}
