//
//  SignUpViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol SignUpDisplayLogic: class {
    func setup(router: SignUpRouting)
}

final class SignUpViewController: UIViewController {
    private var router: SignUpRouting?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    deinit {
        router = nil
    }
}

private extension SignUpViewController {
    func setupViews() {
        setupNavigationBar()
        view.backgroundColor = .white
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkText]
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "Account"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: router,
            action: #selector(router!.dismiss)
        )
    }
    
}

extension SignUpViewController: SignUpDisplayLogic {
    func setup(router: SignUpRouting) {
        self.router = router
    }
}
