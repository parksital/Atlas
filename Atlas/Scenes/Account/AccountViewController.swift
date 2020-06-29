//
//  AccountViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 20/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol AccountDisplayLogic: class {
    func setup(interactor: AccountInteraction)
    func setup(router: AccountRouterProtocol)
    func showSignUpView()
    func displayAccount(for user: User?)
    func displaySettings(settings: [String])
}

final class AccountViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<AccountSectionType, AccountItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<AccountSectionType, AccountItem>
    
    private var interactor: AccountInteraction?
    private var router: AccountRouterProtocol?
    private var tableView: UITableView! = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension AccountViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation() {
        navigationItem.title = "Account"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerTableViewViewCells()
        setupTableViewConstraints()
    }
    
    func registerTableViewViewCells() {
        tableView.register(
            NoProfileTableViewCell.self,
            forCellReuseIdentifier: String(describing: NoProfileTableViewCell.self)
        )
        
        tableView.register(
            UserProfileTableViewCell.self,
            forCellReuseIdentifier: String(describing: UserProfileTableViewCell.self)
        )
        
        tableView.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: String(describing: SettingTableViewCell.self)
        )
    }
    
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
}

extension AccountViewController: UITableViewDelegate {
    
}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoProfileTableViewCell.self)) as? NoProfileTableViewCell ?? NoProfileTableViewCell()
        cell.action = interactor?.goToSignUp
        cell.configure()
        return cell
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
    
    func displayAccount(for user: User?) {
    }
    
    func displaySettings(settings: [String]) {
    }
}
