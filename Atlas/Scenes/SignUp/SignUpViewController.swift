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
    func displayActivityIndicator()
    func setupWithViewModel(_ viewModel: SignUpViewModel)
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
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
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
        setupActivityIndicatorConstraints()
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
    
    func setupActivityIndicatorConstraints() {
        authView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let leading = activityIndicator.leadingAnchor.constraint(equalTo: authButton.trailingAnchor, constant: 16.0)
        let centerY = activityIndicator.centerYAnchor.constraint(equalTo: authButton.centerYAnchor)
        
        NSLayoutConstraint.activate([leading, centerY])
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
    
    func updateValuesWithViewModel(_ viewModel: SignUpViewModel) {
        mainLabel.text = viewModel.mainText
        secondaryLabel.text = viewModel.secondaryText
    }
    
    func disableDismissal() {
        self.isModalInPresentation = true
        view.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak activityIndicator] in
            activityIndicator?.stopAnimating()
        }
    }
}

extension SignUpViewController: SignUpDisplayLogic {
    func setupWithViewModel(_ viewModel: SignUpViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.updateValuesWithViewModel(viewModel)
        }
    }
    
    func displayActivityIndicator() {
        disableDismissal()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func signUpSuccessful() {
        hideActivityIndicator()
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
