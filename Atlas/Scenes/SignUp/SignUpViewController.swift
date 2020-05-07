//
//  SignUpViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit
import AloeStackView
import AuthenticationServices

protocol SignUpDisplayLogic: class {
    func signUpSuccessful()
    func showActivityIndicator()
    func hideActivityIndicator()
    func updateWithViewModel(_ viewModel: SignUpViewModel)
    func setup(interactor: SignUpInteraction)
    func setup(router: SignUpRouterProtocol)
}

final class SignUpViewController: UIViewController {
    private var interactor: SignUpInteraction?
    private var router: SignUpRouterProtocol?
    
    private var aloeStackView = AloeStackView()
    private var mainLabel = UILabel(styling: .primary)
    private var secondaryLabel = UILabel(styling: .secondary)
    private var authView = UIView()
    private var authButton: ASAuthorizationAppleIDButton!
    
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
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let userInterfaceHasChanged = traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)

        if userInterfaceHasChanged {
            setupAppleIDAuthButton()
        }
    }
    
    deinit {
        router = nil
        interactor = nil
    }
}

private extension SignUpViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupAloeStackView()
        
        setupMainLabel()
        setupSecondaryLabel()
        setupAppleIDAuthButton()
        setupAuthView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "Account"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: router,
            action: #selector(router!.dismiss)
        )
    }
    
    func setupAloeStackView() {
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
    
    func setupMainLabel() {
        aloeStackView.addRow(mainLabel, animated: true)
    }
    
    func setupSecondaryLabel() {
        aloeStackView.addRow(secondaryLabel, animated: true)
    }
    
    func setupAuthView() {
        aloeStackView.addRow(authView, animated: true)
    }
    
    func setupAppleIDAuthButton() {
        authView.subviews.forEach { $0.removeFromSuperview() }
        switch traitCollection.userInterfaceStyle {
        case .dark:
            authButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
        default:
            authButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
        }
        
        authButton.addTarget(self, action: #selector(self.handleAppleIDButtonPress), for: .touchUpInside)
        
        setupAuthButtonConstraints()
    }
    
    func setupAuthButtonConstraints() {
        authView.addSubview(authButton)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        
        let width = authButton.widthAnchor.constraint(equalToConstant: 200.0)
        let height = authButton.heightAnchor.constraint(equalToConstant: 44.0)
        let top = authButton.topAnchor.constraint(equalTo: authView.topAnchor)
        let bottom = authButton.bottomAnchor.constraint(equalTo: authView.bottomAnchor)
        let centerX = authButton.centerXAnchor.constraint(equalTo: authView.centerXAnchor)
        
        NSLayoutConstraint.activate([centerX, width, height, top, bottom])
    }
    
    @objc func handleAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func updateViewsForViewModel(_ viewModel: SignUpViewModel) {
        mainLabel.text = viewModel.mainText
        secondaryLabel.text = viewModel.secondaryText
    }
}

extension SignUpViewController: SignUpDisplayLogic {
    func updateWithViewModel(_ viewModel: SignUpViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.updateViewsForViewModel(viewModel)
        }
    }
    
    func showActivityIndicator() {
        
    }
    
    func hideActivityIndicator() {
        
    }
    
    func signUpSuccessful() {
        router?.dismiss()
    }
    
    func setup(interactor: SignUpInteraction) {
        self.interactor = interactor
    }
    
    func setup(router: SignUpRouterProtocol) {
        self.router = router
    }
}

extension SignUpViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credentials = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = credentials.identityToken
            else {
                interactor?.handleCredentialsError()
                return
        }
        
        let authData = AppleAuthData(
            uid: credentials.user,
            email: credentials.email!,
            fullName: credentials.fullName!,
            token: String(data: tokenData, encoding: .utf8)!
        )
        
        interactor?.signUpWithAppleID(authData: authData)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

extension SignUpViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
