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
    func displaySignedOutView()
}

final class AccountViewController: UIViewController {
    private var interactor: AccountInteraction?
    private var router: AccountRouterProtocol?
    
    private let aloeStackView = AloeStackView()
    private let greetingLabel = UILabel()
    private let infoLabel = UILabel()
    private let signInButton = UIButton(type: .roundedRect)
    
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
        setupAloeStackview()
        setupGreetingLabel()
        setupInfolabel()
        setupSignInButton()
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
    
    func setupGreetingLabel() {
        greetingLabel.applyStyling(.primary)
        aloeStackView.addRow(greetingLabel)
    }
    
    func setupInfolabel() {
        infoLabel.applyStyling(.headline)
        aloeStackView.addRow(infoLabel)
        aloeStackView.showSeparator(forRow: infoLabel)
    }
    
    func setupSignInButton() {
        signInButton.addTarget(
            self,
            action: #selector(self.signUpTapped),
            for: .touchUpInside
        )
        
        
        signInButton.setTitle("Sign me up!", for: .normal)
        aloeStackView.addRow(signInButton)
    }
    
    @objc func signUpTapped() {
        interactor?.goToSignUp()
    }
    
    func updateViewForUser(user: String) {
        aloeStackView.removeRow(signInButton)
        greetingLabel.text = "Hello, \(user)"
        
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
    
    func displaySignedOutView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.greetingLabel.text = "Greetings, it seems you're not signed up yet."
        }
    }
}
