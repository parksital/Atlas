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
    func showSelectedSetting()
}

final class AccountViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<AccountSectionType, AccountItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<AccountSectionType, AccountItem>
    
    private var interactor: AccountInteraction?
    private var router: AccountRouterProtocol?
    
    private var dataSource: DataSource?
    private var currentSnapshot: Snapshot?
    
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
        registerTableViewViewCells()
        setupTableViewConstraints()
        configureTableViewDatasource()
        setInitialSnapshot()
    }
    
    func registerTableViewViewCells() {
        tableView.register(cellType: NoProfileTableViewCell.self)
        tableView.register(cellType: UserProfileTableViewCell.self)
        tableView.register(cellType: SettingTableViewCell.self)
    }
    
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let top = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func configureTableViewDatasource() {
        dataSource = DataSource(tableView: tableView) { [interactor] (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .noProfile:
                let cell: NoProfileTableViewCell = tableView.getCell(forIndexPath: indexPath)
                cell.action = interactor?.goToSignUp
                cell.configure()
                return cell
            case .profile(let user):
                let cell: UserProfileTableViewCell = tableView.getCell(forIndexPath: indexPath)
                cell.setup(firstName: user.firstName, lastName: user.familyName)
                return cell
            case .setting(let title):
                let cell: SettingTableViewCell = tableView.getCell(forIndexPath: indexPath)
                cell.configure(title: title)
                return cell
            }
        }
    }
    
    func setInitialSnapshot() {
        currentSnapshot = Snapshot()
        currentSnapshot?.appendSections(AccountSectionType.allCases)
        dataSource?.apply(currentSnapshot!, animatingDifferences: false)
    }
    
    func appendSnapshot(forSection sectionType: AccountSectionType, with items: [AccountItem], animated: Bool = false) {
        currentSnapshot?.appendItems(items, toSection: sectionType)
        dataSource?.apply(currentSnapshot!, animatingDifferences: animated)
    }
    
    func updateSnapshot(user: User?) {
        currentSnapshot?.deleteSections([.userProfileSection])
        currentSnapshot?.insertSections([.userProfileSection], beforeSection: .settingsSection)
        
        let item: AccountItem = user == nil ? .noProfile : .profile(user!)
        appendSnapshot(forSection: .userProfileSection, with: [item])
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.didSelectItem(atIndex: indexPath)
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
        DispatchQueue.main.async { [weak self] in
            self?.updateSnapshot(user: user)
        }
    }
    
    func displaySettings(settings: [String]) {
        DispatchQueue.main.async { [weak self] in
            self?.appendSnapshot(
                forSection: .settingsSection,
                with: settings.map(AccountItem.init(setting:))
            )
        }
    }
    
    func showSelectedSetting() {
        router?.routeToSelectedSetting()
    }
}
