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
    private var viewModel: SignUpViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            mainLabel.text = vm.mainText
            secondaryLabel.text = vm.secondaryText
        }
    }
    
    private var scrollViewComponent = ScrollViewComponent()
    private var stackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        return stackView
    }()
    
    private var mainLabel = UILabel(styling: .primary)
    private var secondaryLabel = UILabel(styling: .secondary)
    
    private let authButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
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
    
    deinit {
        router = nil
        interactor = nil
    }
}

private extension SignUpViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
//        setupLabels()
        setupAuthButton()
        setupStackView()
        setupScrollViewComponent()
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
    
    func setupLabels() {
        [mainLabel, secondaryLabel].forEach { label in
            label.adjustsFontForContentSizeCategory = true
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
            label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        }
    }
    
    func setupAuthButton() {
        authButton.addTarget(self, action: #selector(self.handleAppleIDButtonPress), for: .touchUpInside)
        setupAuthButtonConstraints()
    }
    
    func setupAuthButtonConstraints() {
        view.addSubview(authButton)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        let center = authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let bottom = authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0)
        
        NSLayoutConstraint.activate([center, bottom])
    }
    
    func setupStackView() {
        stackView.populateWithViews([mainLabel, secondaryLabel, authButton])
        stackView.addSpacer()
    }
    
    func setupScrollViewComponent() {
        scrollViewComponent.isScrollEnabled = false
        scrollViewComponent.setupWithView(stackView)
        setupScrollComponentConstraints()
    }
    
    func setupScrollComponentConstraints() {
        view.addSubview(scrollViewComponent)
        
        scrollViewComponent.translatesAutoresizingMaskIntoConstraints = false
        let leading = scrollViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = scrollViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = scrollViewComponent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = scrollViewComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
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
            self?.viewModel = viewModel
//            self?.updateViewsForViewModel(viewModel)
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
