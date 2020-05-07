//
//  AccountViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol AccountDisplayLogic: class {
    func setup(interactor: AccountInteraction)
    func setup(router: AccountRouterProtocol)
    func displaySignedOutView()
}

final class AccountViewController: UIViewController {
    private var interactor: AccountInteraction?
    private var router: AccountRouterProtocol?
    private var statusLabel: UILabel = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.viewDidFinishLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

private extension AccountViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupStatusLabel()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Account"
    }
    
    func setupStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0)
        let centerX = statusLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0.0)
        
        NSLayoutConstraint.activate([top, centerX])
    }
}

extension AccountViewController: AccountDisplayLogic {
    func setup(interactor: AccountInteraction) {
        self.interactor = interactor
    }
    func setup(router: AccountRouterProtocol) {
        self.router = router
    }
    
    func displaySignedOutView() {
        DispatchQueue.main.async { [statusLabel] in
            statusLabel.text = "signed out"
        }
    }
}
