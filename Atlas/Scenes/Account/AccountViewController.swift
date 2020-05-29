//
//  AccountViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit
import AloeStackView

protocol AccountDisplayLogic: class {
    func setup(interactor: AccountInteraction)
    func setup(router: AccountRouterProtocol)
    func showSignUpView()
    func displayAccount(viewModel: String)
}

final class AccountViewController: UIViewController {
    private var interactor: AccountInteraction?
    private var router: AccountRouterProtocol?
    
    private let aloeStackView = AloeStackView()
    private var emptyAccountView = EmptyAccountView()
    private var userInfoView = AccountUserInfoView()
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension AccountViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupAloeStackview()
        setupEmptyAccountView(withAction: interactor?.goToSignUp)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Account"
    }
    
    func setupAloeStackview() {
        aloeStackView.hidesSeparatorsByDefault = true
        aloeStackView.alwaysBounceVertical = true
        aloeStackView.backgroundColor = .systemBackground
        aloeStackView.rowBackgroundColor = .systemBackground
        aloeStackView.separatorColor = .separator
        
        setupAloeStackViewConstraints()
    }
    
    func setupAloeStackViewConstraints() {
        view.addSubview(aloeStackView)
        
        aloeStackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = aloeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = aloeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = aloeStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = aloeStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupEmptyAccountView(withAction action: (() -> (Void))?) {
        emptyAccountView.action = action
        emptyAccountView.configure()
        aloeStackView.addRow(emptyAccountView, animated: true)
    }
    
    func updateViewForUser(user: String) {
        aloeStackView.removeAllRows(animated: false)
        aloeStackView.addRow(userInfoView, animated: true)
        // add all other views
    }
}

extension AccountViewController: AccountDisplayLogic {
    func setup(interactor: AccountInteraction) {
        self.interactor = interactor
    }
    func setup(router: AccountRouterProtocol) {
        self.router = router
    }
    
    func showSignUpView() {
        router?.routeToSignUp()
    }
    
    func displayAccount(viewModel: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateViewForUser(user: viewModel)
        }
    }
}
