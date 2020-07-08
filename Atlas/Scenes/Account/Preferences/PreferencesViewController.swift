//
//  PreferencesViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol PreferencesDisplayLogic: class {
    func setup(interactor: PreferencesInteraction)
    func setup(router: PreferencesRouterProtocol)
    func displayAlert()
    func displayWipeCompleted()
    func displayWipeFailure()
}

final class PreferencesViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<PreferenceSectionType, PreferenceItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PreferenceSectionType, PreferenceItem>
    
    private var interactor: PreferencesInteraction?
    private var router: PreferencesRouterProtocol?
    
    private var dataSource: DataSource?
    private var currentSnapshot: Snapshot?
    
    private let tableView: UITableView = {
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

private extension PreferencesViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation() {
        navigationItem.title = "Preferences"
    }
    
    func setupTableView() {
        registerTableViewViewCells()
        setupTableViewConstraints()
        configureTableViewDatasource()
        setInitialSnapshot()
    }
    
    func registerTableViewViewCells() {
        tableView.register(cellType: WipeKeychainCell.self)
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
            case .wipeKeychain(let wiped):
                let cell: WipeKeychainCell = tableView.getCell(forIndexPath: indexPath)
                cell.action = interactor?.wipeKeychainButtonTapped
                cell.configure(wiped: wiped)
                return cell
            }
        }
    }
    
    func setInitialSnapshot() {
        currentSnapshot = Snapshot()
        currentSnapshot?.appendSections(PreferenceSectionType.allCases)
        currentSnapshot?.appendItems([.wipeKeychain(nil)], toSection: .preferences)
        dataSource?.apply(currentSnapshot!, animatingDifferences: false)
    }
    
    func updateSnapshot(items: [PreferenceItem], sectionType: PreferenceSectionType) {
        currentSnapshot?.deleteSections([sectionType])
        currentSnapshot?.appendSections([sectionType])
        currentSnapshot?.appendItems(items, toSection: sectionType)
        dataSource?.apply(currentSnapshot!, animatingDifferences: true)
    }
    
    func createAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Passphrase required",
            message: "This is a temporary measure. Please contact the developer to obtain the passphrase.",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Passphrase"
        })
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel)

        let wipe = UIAlertAction(
            title: "Wipe Keychain",
            style: .destructive,
            handler: { [alert, interactor] action in
                guard
                    let passphrase = alert.textFields?.first?.text
                    else { return }
                
                interactor?.checkPassphrase(passphrase)
            }
        )
        
        alert.addAction(wipe)
        alert.addAction(cancel)
        
        return alert
    }
}

extension PreferencesViewController: PreferencesDisplayLogic {
    func setup(interactor: PreferencesInteraction) {
        self.interactor = interactor
    }
    
    func setup(router: PreferencesRouterProtocol) {
        self.router = router
    }
    
    func displayAlert() {
        let alert = createAlert()
        router?.presentAlert(alert)
    }
    
    func displayWipeCompleted() {
        updateSnapshot(items: [.wipeKeychain(true)], sectionType: .preferences)
    }
    
    func displayWipeFailure() {
        updateSnapshot(items: [.wipeKeychain(false)], sectionType: .preferences)
    }
}
